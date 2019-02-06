sudo ipa-server-install -p mypassword -a adminipa -n example.com -r EXAMPLE.COM \
                   --setup-kra --setup-dns --forwarder=8.8.8.8 --hostname=ipaserver.example.com \
                   --auto-reverse -U --allow-zone-overlap
