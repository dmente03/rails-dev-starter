Exec { path => "/home/vagrant/bin:/usr/local/rbenv/bin:/usr/local/rbenv/shims::/usr/local/rbenv/shims/bin:/usr/bin:/bin:/usr/sbin:/sbin" }

exec { "apt-update":
  command => "/usr/bin/apt-get update",
  onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
}

Exec["apt-update"] -> Package <| |>

package { "libpq-dev": ensure => present }
package { "nodejs": ensure => present }

# --- Ruby ---------------------------------------------------------------------
class { "rbenv": }

rbenv::plugin { "sstephenson/ruby-build": }
rbenv::plugin { "ianheggie/rbenv-binstubs": }
rbenv::plugin { "sstephenson/rbenv-gem-rehash": }

rbenv::build { "2.4.0":
  global => true,
  require => [Rbenv::Plugin["sstephenson/ruby-build"], Rbenv::Plugin["ianheggie/rbenv-binstubs"], Rbenv::Plugin["sstephenson/rbenv-gem-rehash"]]
}

# --- Rails ---------------------------------------------------------------------
$essential_packages = ["nginx", "libsqlite3-dev", "sqlite3", "imagemagick", "libxml2", "libxml2-dev", "libxslt1-dev"]
package { $essential_packages:
  ensure   => 'installed'
}

package { "rails":
  ensure   => 'installed',
  provider => 'gem',
  require  => Package[$essential_packages]
}