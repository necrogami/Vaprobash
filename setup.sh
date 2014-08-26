#!/bin/bash

# Config Github Settings
GITHUB_USERNAME="necrogami"
GITHUB_REPO="Vaprobash"
GITHUB_BRANCH="master"
GITHUB_URL="https://raw.githubusercontent.com/${GITHUB_USERNAME}/${GITHUB_REPO}/${GITHUB_BRANCH}"

# Server Configuration

# Hostname
HOSTNAME="vaprobash.dev"

# Make sure the Keys are there.
sudo apt-key adv -qq --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5 3B4FE6ACC0B21F32

# Required Server Info
SERVER_IP="192.168.2.143"
SERVER_MEMORY="8192" # MB
SERVER_SWAP="8192" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

# UTC        for Universal Coordinated Time
# EST        for Eastern Standard Time
# US/Central for American Central
# US/Eastern for American Eastern
SERVER_TIMEZONE="UTC"

# Database Configuration
MYSQL_ROOT_PASSWORD="root"   # We'll assume user "root"
MYSQL_VERSION="5.5"    # Options: 5.5 | 5.6
MYSQL_ENABLE_REMOTE="false"  # remote access enabled when true
PGSQL_ROOT_PASSWORD="root"   # We'll assume user "root"
MONGO_ENABLE_REMOTE="false"  # remote access enabled when true

# Languages and Packages
PHP_TIMEZONE="UTC"    # http://php.net/manual/en/timezones.php
RUBY_VERSION="latest" # Choose what ruby version should be installed (will also be the default version)
RUBY_GEMS=(        # List any Ruby Gems that you want to install
  #"jekyll",
  #"sass",
  #"compass",
)

# To install HHVM instead of PHP, set this to "true"
HHVM="false"

# PHP Options
COMPOSER_PACKAGES=(        # List any global Composer packages that you want to install
  #"phpunit/phpunit:4.0.*",
  #"codeception/codeception=*",
  #"phpspec/phpspec:2.0.*@dev",
  #"squizlabs/php_codesniffer:1.5.*",
)

# Default web server document root
# Symfony's public directory is assumed "web"
# Laravel's public directory is assumed "public"
PUBLIC_FOLDER="/srv/www"

LARAVEL_ROOT_FOLDER="/srv/www/laravel" # Where to install Laravel. Will `composer install` if a composer.json file exists
LARAVEL_VERSION="latest-stable" # If you need a specific version of Laravel, set it here
SYMFONY_ROOT_FOLDER="/srv/www/symfony" # Where to install Symfony.

NODEJS_VERSION="latest"   # By default "latest" will equal the latest stable version
NODEJS_PACKAGES=(          # List any global NodeJS packages that you want to install
  #"grunt-cli",
  #"gulp",
  #"bower",
  #"yo",
)


check_and_run () {
  if [ ! -d "scripts" ]; then
    mkdir scripts
  fi

  if [ ! -f "$1" ]; then
    wget ${GITHUB_URL}/scripts/$1 -O scripts/$1
  fi

  bash scripts/$1 $2 $3 $4 $5
}



####
# Base Items
##########

# Provision Base Packages
check_and_run base.sh GITHUB_URL SERVER_SWAP SERVER_TIMEZONE

# Provision PHP
check_and_run php.sh PHP_TIMEZONE HHVM

# Enable MSSQL for PHP
# check_and_run mssql.sh

# Provision Vim
check_and_run vim.sh GITHUB_URL


####
# Web Servers
##########

# Provision Apache Base
# check_and_run apache.sh SERVER_IP PUBLIC_FOLDER HOSTNAME GITHUB_URL

# Provision Nginx Base
check_and_run nginx.sh SERVER_IP PUBLIC_FOLDER HOSTNAME GITHUB_URL


####
# Databases
##########

# Provision MySQL
check_and_run mysql.sh MYSQL_ROOT_PASSWORD MYSQL_VERSION MYSQL_ENABLE_REMOTE

# Provision PostgreSQL
# check_and_run pgsql.sh PGSQL_ROOT_PASSWORD

# Provision SQLite
# check_and_run sqlite.sh

# Provision RethinkDB
# check_and_run rethinkdb.sh PGSQL_ROOT_PASSWORD

# Provision Couchbase
# check_and_run couchbase.sh

# Provision CouchDB
# check_and_run couchdb.sh

# Provision MongoDB
# check_and_run mongodb.sh MONGO_ENABLE_REMOTE

# Provision MariaDB
# check_and_run mariadb.sh MYSQL_ROOT_PASSWORD MYSQL_ENABLE_REMOTE

####
# Search Servers
##########

# Install Elasticsearch
# check_and_run elasticsearch.sh

# Install SphinxSearch
# check_and_run sphinxsearch.sh

####
# Search Server Administration (web-based)
##########

# Install ElasticHQ
# Admin for: Elasticsearch
# Works on: Apache2, Nginx

# check_and_run elastichq.sh


####
# In-Memory Stores
##########

# Install Memcached
# check_and_run memcached.sh

# Provision Redis (without journaling and persistence)
check_and_run redis.sh

# Provision Redis (with journaling and persistence)
# check_and_run redis.sh "persistent"
# NOTE: It is safe to run this to add persistence even if originally provisioned without persistence


####
# Utility (queue)
##########

# Install Beanstalkd
check_and_run beanstalkd.sh

# Install Supervisord
check_and_run supervisord.sh

# Install ØMQ
# check_and_run zeromq.sh

####
# Additional Languages
##########

# Install Nodejs
# check_and_run nodejs.sh nodejs_packages.unshift($(NODEJS_VERSION), $(GITHUB_URL))

# Install Ruby Version Manager (RVM)
# check_and_run rvm.sh ruby_gems.unshift($(RUBY_VERSION))

####
# Frameworks and Tooling
##########

# Provision Composer
check_and_run composer.sh composer_packages.join(" ")

# Provision Laravel
# check_and_run laravel.sh SERVER_IP LARAVEL_ROOT_FOLDER PUBLIC_FOLDER LARAVEL_VERSION

# Provision Symfony
# check_and_run symfony.sh SERVER_IP SYMFONY_ROOT_FOLDER PUBLIC_FOLDER

# Install Screen
check_and_run screen.sh

# Install Mailcatcher
# check_and_run mailcatcher.sh

# Install git-ftp
# check_and_run git-ftp.sh
