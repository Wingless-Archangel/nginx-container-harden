# Nginx Docker Hardening

## Introduction

This is an attempt to harden NGINX within the container environment. The base docker image is `nginx:latest` image.

## What I have hardened

- prevent Clickjacking via `X-Frame-Options`
- mitigate Cross Site Scripting (XSS) via Content Security Policy, `Content-Security-Policy`, and `X-XSS-Protection`
- limit buffer on request to mitigate buffer overflow.
- configure time out to prevent some Denial of Service Attack
- disable weak SSL/TLS protocols and ciphers
- provide the example CORS configuration if required
- disable MIME type sniffing
- enable HSTS

## Warning

This image is not just run and ready in the `Production` there are something you need to aware as shown below.

### Docker-compose

by default, the binding port is `8000 for http` and `8443 for https`. Please change it to the one you are really using.

### Nginx configuration file

The configuration file is `default.conf`. What needs to be done are

- configure the proper server name in `server_name`
- send logs to the external Syslog server. By Default, NGINX log locally but to improve the security and visibility, the log should be send to centralized log server
- If you are paranoid, you can re-generate the new Diffie-Hellman parameters. the generated DH size is 4096 bit.

#### SSL Certificate

The provided ssl certificate is the `self-signed` one. You need to change it to the proper `CA-signed` certificate

### Security configuration file

for `Buffer Overflow mitigation` and `Denial of Service Attack`, the value may be vary based on the actual request in the environment. the takeaway is we have to limit to the proper amount to mitigate these attacks.

### CORS configuration file

In case you need to use CORS, there are some concerns for CORS configuration as shown below.

- do not put `*` in `Access-Control-Allow-Origin`.
- validate the remote site properly before add `Access-Control-Allow-Credentials: true` since it could introduce XSS.
- Don't rely only on the `Origin` header for Access Control checks. we still need to validate the input again.