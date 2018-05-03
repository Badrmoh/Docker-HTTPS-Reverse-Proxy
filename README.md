# Docker HTTPS Reverse Proxy 
This is a project in which we containerize a HTTPS reverse proxy, namely NGINX, using Docker.  
## Getting Started
Next, a guide on how to use the Revere Proxy is presented.
### Prequsites
Three main parts are needed for this project to be properly working; Docker, NGINX, and Certbot. The version used are shown below, however, it is expected that latest versions will do the job as well. 

**Docker version:**
`1.13.1, build 092cba3`

**NGINX version:**
`1.13.8`

**Certbot version:**
`0.19.0`

You can install these preuisites following the instructions on their official websites.

Other presuisites regarding the OS and the Docker image:

**OS Used:**
```
# cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.3 LTS"
```

**Docker image:**
```
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.3 LTS"
```

**UFW:**

Make sure that the host's firewall allows ports 80, 443, and 53. Preferably, make the testing with it being turned off.
```
# ufw status
Status: inactive
```

**Network's Firewall**

Make sure that the host is allowed to comunicate on ports 80, 443, and 53. This might require some configuration, anyway, this part is not covered in this documentation.

### Important Directories and Files

**NGINX Configuration File**

This file is inside the running container NOT the host.

```
/etc/nginx/nginx.conf
```

The NGINX configuration file is mounted from the root directory to this point, so ou don't have to reconfigure every time you need to deploy the same Reverse Proxy.

**Docker file**

This one lies in the root directory of this project, such that mounts and copy points work properly.

**Certificates**

Certificates are copied and stored externally in the root directory under Let's Encrypt directory, so they become reusable if the container is stopped or re-run. Following, is the root directory where all files and directories lie.

```
$ ls
Dockerfile letsencrypt/ nginx.conf
```

## Configurations


### NGINX Configuration

Configurations required to enable HTTPS are automatically added to NGINX's configuration file, thanks to Certbot. Below, is a template of a Virtual Host that users can customize to fit in their situations.

```
server {
    listen <port>;
    server_name <You Domain Name>;
    location / {
     proxy_pass <IP or Domain Name of the target>;
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
} }
```

### Certificate Renewal

Let’s Encrypt can issue certificates that are valid for 90 days. Below, a configuration file that adds an auto-renewal feature is shown:


```
$ cat /letsencrypt/cli.ini
#domains = domain1, domain2, ....etc.
renew-by-default = true
```

In this configuration file domain names can be provided so Certbot automatically configure their corresponding VirtualHosts in the Nginx configuration file and also for adding their configuration files about the renewal.

### Building Docker image

`$ docker build -t image:latest <path-to-Dockerfile>`

If your current working directory is the project's root directory then the the command will be:

`$ docker build -t image:latest Dockerfile`

## Deployment

Running docker container is trivial but certain considerations must be taken care of to ensure the container running properly. First is to mount the folder that is used to store and provide certificates and configuration of the domain. Also, port mapping has to be done properly so challenges can be transverse to the container without any problems. Next, the run command with all these considerations are shown:

```
$ docker run -it -p 80:80 -p 443:443 $(pwd)/letsencrypt:/etc/letsencrypt
  -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf image:latest
```

After running the previous command, it will prompt the user asking about domains to select and also about whether to redirect HTTP request to HTTPS or not. If the user wants to use existing certificates, he can use the same command above, and cancels the prompt of the Certbot. Automatically, Nginx will start using the old certificates. Note that this needs certificates to exist and the Nginx is configured to use them at their path. At this point, container is running normally and HTTPS is deployed if certificates are available and Nginx is properly configured.


## Authors

Badr Ibrahim 

## Project's Contributors 

Badr Ibrahim
Hossam Alzamly

## License

This project is licensed under the MIT License.

## Detailed Documentation

Contact us by email.
