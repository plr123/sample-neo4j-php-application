class bootstrap {

    group { 'puppet':
        ensure  => 'present',
        require => Exec['apt-get update']
    }
    
    exec { 'locale-gen en_GB.UTF-8':
        command => 'locale-gen en_GB.UTF-8',
        require => Exec['apt-get update']
    }
    
    exec { 'set home directory':
        command => 'echo "if [ -d /vagrant ]; then cd /vagrant; fi" >> /home/vagrant/.bashrc',
        creates => '/home/vagrant/.bashrc'
    }

    exec { 'set nameservers':
        command => 'echo "nameserver 8.8.8.8\nnameserver 8.8.4.4" >> /etc/resolvconf/resolv.conf.d/head',
        unless  => "grep -c 'nameserver 8.8.8.8'"
    }

    exec { 'update resolvconf':
        command => 'resolvconf -u',
        require => Exec['set nameservers']
    }
    
    exec { 'create swap':
        command => 'fallocate -l 2G /swapfile',
        creates => '/swapfile'
    }
    
    exec { 'chmod swap':
        command => 'chmod 600 /swapfile',
        unless  => 'test $(stat -c %a /swapfile) = 600',
        require => Exec['create swap']
    }
    
    exec { 'setup swap':
        command => 'mkswap /swapfile',
        require => Exec['chmod swap'],
        unless  => 'swapon -s | grep /swapfile'
    }
    
    exec { 'enable swap':
        command => 'swapon /swapfile',
        require => Exec['setup swap'],
        unless  => 'swapon -s | grep /swapfile'
    }
}