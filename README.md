# IPA Server setup

This vagrantfile can create a basic IPA server useful to emulate an RHCSA test.

Not all the steps can be automated in this moment, so you will need to proceed
manually for certain things.

## How to start the vm

    vagrant up
    vagrant ssh

You can login to the IPA server with 'admin' and password 'adminipa'.

## Manual procedure

*IMPORTANT*: This is not needed anymore since it has been automatized in the
Vagrantfile.

You can setup the IPA server using the tools from RedHat like in the following
procedure:

    [vagrant@ipaserver ~]$ sudo -i
    [root@ipaserver ~]# ipa-server-install 
    
    The log file for this installation can be found in /var/log/ipaserver-install.log
    ==============================================================================
    This program will set up the IPA Server.
    
    This includes:
      * Configure a stand-alone CA (dogtag) for certificate management
      * Configure the Network Time Daemon (ntpd)
      * Create and configure an instance of Directory Server
      * Create and configure a Kerberos Key Distribution Center (KDC)
      * Configure Apache (httpd)
      * Configure the KDC to enable PKINIT
    
    To accept the default shown in brackets, press the Enter key.
    
    WARNING: conflicting time&date synchronization service 'chronyd' will be disabled
    in favor of ntpd
    
    Do you want to configure integrated DNS (BIND)? [no]: yes
    
    Enter the fully qualified domain name of the computer
    on which you're setting up server software. Using the form
    <hostname>.<domainname>
    Example: master.example.com.
    
    
    Server host name [ipaserver.example.com]: 
    
    Warning: skipping DNS resolution of host ipaserver.example.com
    The domain name has been determined based on the host name.
    
    Please confirm the domain name [example.com]: 
    
    The kerberos protocol requires a Realm name to be defined.
    This is typically the domain name converted to uppercase.
    
    Please provide a realm name [EXAMPLE.COM]: 
    Certain directory server operations require an administrative user.
    This user is referred to as the Directory Manager and has full access
    to the Directory for system management tasks and will be added to the
    instance of directory server created for IPA.
    The password must be at least 8 characters long.
    
    Directory Manager password: mypassword
    Password (confirm): mypassword
    
    The IPA server requires an administrative user, named 'admin'.
    This user is a regular system account used for IPA server administration.
    
    IPA admin password: adminipa
    Password (confirm): adminipa
    
    Checking DNS domain example.com., please wait ...
    Do you want to configure DNS forwarders? [yes]: 
    Following DNS servers are configured in /etc/resolv.conf: 10.0.2.3
    Do you want to configure these servers as DNS forwarders? [yes]: no
    Enter an IP address for a DNS forwarder, or press Enter to skip: 8.8.8.8
    DNS forwarder 8.8.8.8 added. You may add another.
    Enter an IP address for a DNS forwarder, or press Enter to skip: 
    Checking DNS forwarders, please wait ...
    Do you want to search for missing reverse zones? [yes]: 
    Do you want to create reverse zone for IP 192.168.33.10 [yes]: 
    Please specify the reverse zone name [33.168.192.in-addr.arpa.]: 
    Using reverse zone(s) 33.168.192.in-addr.arpa.
    
    The IPA Master Server will be configured with:
    Hostname:       ipaserver.example.com
    IP address(es): 192.168.33.10
    Domain name:    example.com
    Realm name:     EXAMPLE.COM
    
    BIND DNS server will be configured to serve IPA domain with:
    Forwarders:       8.8.8.8
    Forward policy:   only
    Reverse zone(s):  33.168.192.in-addr.arpa.
    
    Continue to configure the system with these values? [no]: yes 
    
    The following operations may take some minutes to complete.
    Please wait until the prompt is returned.
    
    Configuring NTP daemon (ntpd)
      [1/4]: stopping ntpd
      [2/4]: writing configuration
    [...]


## How to add credentials to the IPA server

This row should be in the hosts file where you are running vagrant and the
browser:

    192.168.33.10 ipaserver.example.com

You should proceed with the following changes:

1. add a new host with the address 192.168.33.11 named ipaclient.example.com
2. add a new user as you like


# How to configure an IPA client

Remember to set a password for the root user, otherwise when you will have
configured LDAP authentication you can't access to the VM using Vagrant anymore.
This will not be needed in the exam.

Configure LDAP authentication in the following way:

    [root@ipaclient ~]# yum install -y openldap-clients nss-pam-ldapd
    [...]
    
    [root@ipaclient ~]# authconfig --enableforcelegacy --update
    [root@ipaclient ~]# authconfig --enableldap --enableldapauth --ldapserver="ipaserver.example.com" --ldapbasedn="dc=example,dc=com" --update
    [root@ipaclient ~]# authconfig --update --enablemkhomedir
    [root@ipaclient ~]# authconfig --test

Try authenticating with an user:

    [vagrant@ipaclient ~]$ sudo -iu leonardo
    Creating directory '/home/leonardo'.
    -sh-4.2$ ls -la
    total 12
    drwx------. 2 leonardo leonardo  62 Feb  5 22:07 .

# How to configure autofs to automatically mount home directories

TBD

## References

- https://www.certdepot.net/rhel7-configure-freeipa-server/
- https://www.certdepot.net/ldap-client-configuration-authconfig/
- https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/4/html/Reference_Guide/s2-nfs-client-config-autofs.html
- https://www.howtoforge.com/nfs-server-and-client-on-centos-7
