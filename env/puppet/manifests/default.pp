Exec {
    path => ['/usr/bin', '/bin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/local/sbin']
}

include bootstrap
include apt
include neo4j
include php
include php::cgi
include nginx