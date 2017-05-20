Exec { path => "/home/ubuntu/bin:/usr/local/rbenv/bin:/usr/local/rbenv/shims::/usr/local/rbenv/shims/bin:/usr/bin:/bin:/usr/sbin:/sbin" }

exec { "apt-update":
  command => "/usr/bin/apt-get update",
  onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
}

Exec["apt-update"] -> Package <| |>

package { "libpq-dev": ensure => present }
package { "nodejs": ensure => present }

# --- Ruby ---------------------------------------------------------------------
class { "rbenv": }

rbenv::plugin { "rbenv/ruby-build": }

rbenv::build { "2.4.0":
  global 	=> true,
  require 	=> Rbenv::Plugin["rbenv/ruby-build"]
}

rbenv::gem { "rails":
  ruby_version 	=> '2.4.0',
  require  		=> Rbenv::Build["2.4.0"]
}

# --- Essential Packages ---------------------------------------------------------------------
$essential_packages = ["nginx", "sqlite3", "imagemagick"]
package { $essential_packages:
  ensure   => 'installed'
}
