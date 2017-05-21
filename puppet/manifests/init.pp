Exec { path => "/home/ubuntu/bin:/usr/local/rbenv/bin:/usr/local/rbenv/shims::/usr/local/rbenv/shims/bin:/usr/bin:/bin:/usr/sbin:/sbin" }

exec { "apt-update":
  command => "/usr/bin/apt-get update",
  onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
}

Exec["apt-update"] -> Package <| |>

# --- Ruby ---------------------------------------------------------------------
class { "rbenv": }

rbenv::plugin { "rbenv/ruby-build": }

rbenv::build { "2.4.0":
  global 	=> true,
  require 	=> Rbenv::Plugin["rbenv/ruby-build"]
}

rbenv::gem { "rails":
  ruby_version 	=> "2.4.0",
  require  		=> Rbenv::Build["2.4.0"]
}

# --- Essential Packages ---------------------------------------------------------------------
$essential_packages = [ "nginx", 
												"libsqlite3-dev", 
												"sqlite3", 
												"imagemagick", 
												"libxml2", 
												"libxml2-dev", 
												"libxslt1-dev" ]
package { $essential_packages:
  ensure   => "installed"
}

# --- MySQL ---------------------------------------------------------------------
class install_mysql {
  class { "mysql::server":
    root_password => ""
  }

  package { "libmysqlclient-dev":
    ensure => installed
  }
}
class { "install_mysql": }

# --- PostgreSQL ---------------------------------------------------------------------
class install_postgres {
  class { "postgresql::server": 
  	postgres_password => ""
	}

	package { "libpq-dev":
    ensure => installed
  }
}
class { "install_postgres": }

# --- Node.JS ---------------------------------------------------------------------
class nodejs {
  package { "nodejs":
    ensure  => installed
  }

  package { "npm":
    ensure  => installed,
    require => Package["nodejs"]
  }
}
class { "nodejs": }

# --- Locale ---------------------------------------------------------------------
exec { "update-locale":
	command => "update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8"
}

