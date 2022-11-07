# Create cert (self-signed)
# Choose CN (Common Name)
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

Example:

```sh
ubuntu@control-plane:~$ openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
Generating a RSA private key
.........++++
.............++++
writing new private key to 'key.pem'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:BR
State or Province Name (full name) [Some-State]:SP
Locality Name (eg, city) []:Araraquara
Organization Name (eg, company) [Internet Widgits Pty Ltd]:WCCS
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:wccs.info
Email Address []:me@wccs.info
```

