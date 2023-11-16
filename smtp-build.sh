if [ $# -eq 0 ]
    then
        echo "Usage: smtp-build.sh example.com"
    else
        # installing packages needed
        apt update 
        apt install -y  mailutils postfix opendkim opendkim-tools

        # adding postfix to the opendkim group
        gpasswd -a postfix opendkim

        # setting up opendkim conf file
        rm /etc/opendkim.conf
        touch /etc/opendkim.conf
        echo "Syslog          yes" > /etc/opendkim.conf
        echo "UMask           002" >> /etc/opendkim.conf
        echo "Canonicalization  relaxed/simple" >> /etc/opendkim.conf
        echo "Mode            sv" >> /etc/opendkim.conf
        echo "SubDomains      no" >> /etc/opendkim.conf
        echo "AutoRestart      yes" >> /etc/opendkim.conf
        echo "AutoRestartRate  10/1M" >> /etc/opendkim.conf
        echo "Background       yes" >> /etc/opendkim.conf
        echo "DNSTimeout       5" >> /etc/opendkim.conf
        echo "SignatureAlgorithm      rsa-sha256" >> /etc/opendkim.conf
        echo "OversignHeaders     From" >> /etc/opendkim.conf
        echo "UserID                 opendkim" >> /etc/opendkim.conf
        echo "KeyTable            refile:/etc/opendkim/key.table" >> /etc/opendkim.conf
        echo "SigningTable        refile:/etc/opendkim/signing.table" >> /etc/opendkim.conf
        echo "ExternalIgnoreList  /etc/opendkim/trusted.hosts" >> /etc/opendkim.conf
        echo "InternalHosts /etc/opendkim/trusted.hosts" >> /etc/opendkim.conf
        echo "Socket                local:/var/spool/postfix/opendkim/opendkim.sock" >> /etc/opendkim.conf
        echo "PidFile                 /run/opendkim/opendkim.pid" >> /etc/opendkim.conf

        # creating openkim folder structure and permissions
        mkdir /etc/opendkim
        mkdir /etc/opendkim/keys
        chown -R opendkim:opendkim /etc/opendkim
        chmod go-rw /etc/opendkim/keys

        # creating signing table
        touch /etc/opendkim/signing.table
        echo "*@$1    default._domainkey.$1" >> /etc/opendkim/signing.table

        # creating key table
        touch /etc/opendkim/key.table
        echo "default._domainkey.$1     $1:default:/etc/opendkim/keys/$1/default.private" > /etc/opendkim/key.table

        # creating trusted hosts file
        touch /etc/opendkim/trusted.hosts
        echo "127.0.0.1" > /etc/opendkim/trusted.hosts
        echo "localhost" >> /etc/opendkim/trusted.hosts
        echo "*.$1" >> /etc/opendkim/trusted.hosts

        # creating key directory and generating a dkim key-pair
        mkdir /etc/opendkim/keys/$1
        opendkim-genkey -b 2048 -d $1 -D /etc/opendkim/keys/$1 -s default -v
        chown opendkim:opendkim /etc/opendkim/keys/$1/default.private

        # creating postfix and dkim association
        mkdir /var/spool/postfix/opendkim
        chown opendkim:postfix /var/spool/postfix/opendkim
        sed -i '20d' /etc/default/opendkim
        sed -i '20i SOCKET="local:/var/spool/postfix/opendkim/opendkim.sock"' /etc/default/opendkim
        echo "# Milter configuration" >> /etc/postfix/main.cf
        echo "milter_default_action = accept" >> /etc/postfix/main.cf
        echo "milter_protocol = 6" >>/etc/postfix/main.cf
        echo "smtpd_milters = local:/opendkim/opendkim.sock" >> /etc/postfix/main.cf
        echo 'non_smtpd_milters = $smtpd_milters' >> /etc/postfix/main.cf

        # display public dkim key
        cat /etc/opendkim/keys/$1/default.txt

        # restarting services
        service opendkim restart
        service postfix restart
fi