# Generate Self signed certificates using below process.

1. Export the variable with your domian name

		export prefix="mydomain"
		cp /usr/lib/ssl/openssl.cnf $prefix.cnf

2. Modify the below section in $prefix.cnf

		[ v3_ca ]
		subjectKeyIdentifier=hash
		authorityKeyIdentifier=keyid:always,issuer
		basicConstraints = critical, CA:TRUE, pathlen:3
		keyUsage = critical, cRLSign, keyCertSign
		nsCertType = sslCA, emailCA

3. Modify the below section in $prefix.cnf

		[ v3_req ]
		basicConstraints = CA:FALSE
		keyUsage = nonRepudiation, digitalSignature, keyEncipherment
		#extendedKeyUsage=serverAuth
		subjectAltName = @alt_names

		[ alt_names ]
		IP.1 = 127.0.0.1
		DNS.1 = mydomain.com 
		DNS.2 = *.dydomain.com
		DNS.3 = localhost

4. Also uncomment the following line in $prefix.cnf

		req_extensions = v3_req

# Process

1. Create CA certificates

		openssl genrsa -aes256 -out ca.key.pem 2048
		chmod 400 ca.key.pem

2. Create self-signed root CA certificate

		openssl req -new -x509 -subj "/CN=myca" -extensions v3_ca -days 3650 -key ca.key.pem -sha256 -out ca.pem -config $prefix.cnf

3. You can verify this root CA certificate using:
	
		openssl x509 -in ca.pem -text -noout

4. Create Server certificate signed by CA

		openssl genrsa -out $prefix.key.pem 2048

5. create the server cert signing request:

		openssl req -subj "/CN=$prefix" -extensions v3_req -sha256 -new -key $prefix.key.pem -out $prefix.csr

6. Then generate the server certificate using the: server signing request, the CA signing key, and CA cert.

		openssl x509 -req -extensions v3_req -days 3650 -sha256 -in $prefix.csr -CA ca.pem -CAkey ca.key.pem -CAcreateserial -out $prefix.crt -extfile $prefix.cnf

7. The “$prefix.key.pem” is the server private key and “$prefix.crt” is the server certificate.  Verify the certificate:

		openssl x509 -in $prefix.crt -text -noout

8. Certificate full chain with private key

		cat $prefix.crt ca.pem $prefix.key.pem > $prefix-ca-full-chain.pem

9. Certificate full chain without private key

		cat $prefix.crt ca.pem> $prefix-full-chain.pem