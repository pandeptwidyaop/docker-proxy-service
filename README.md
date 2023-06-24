# Docker Proxy Service
Proxy your private service over SSH through your container
## About
This docker image help you to expose port securely on `Virtual Machine` to a container over SSH.

## Usage

Available environment variable

| Variable | Description |
-----------| ------------|
|`HOST` | Server host or IP (required)| 
|`SSH_PORT` | SSH Port server default `22` |
|`SSH_USER` | SSH User (required) |
|`SSH_KEY_BASE64`| SSH private key converted to base64 encoded, you can use [this tool](https://www.base64encode.org/) (required) |
|`PORT` | Server port forward to container port `8866` (required)|

### Docker Repository

```sh
docker pull pandeptwidyaop/proxy-service
```

### Docker Run Command
```sh
docker run --env HOST=my-mysql-server.com \
    --env SSH_PORT=22 \
    --env SSH_USER=root \
    --env SSH_KEY_BASE64={your_ssh_key_base64_encoded} \
    --env PORT=3306 \
    pandeptwidyaop/proxy-service:latest
```

and container will be running on port `8866`

### Docker Compose
```yml
version: '3'
services: 
    mysql:
        image: pandeptwidyaop/proxy-service:latest
        env:
            - HOST=my-mysql-server.com
            - SSH_PORT=22
            - SSH_USER=root
            - SSH_KEY_BASE64={your_ssh_key_base64_encoded}
            - PORT=3306
        ports:
            - "3306:8866"
```

### GitLab CI/CD
I also use this `proxy-server` to run automatic migration in my projects pipeline

```yml
stage:
    - build
    - test
    - migrate
    - deploy

...

dev-migrate:
    image: "$CI_REGISTRY_IMAGE"
    stage: migrate
    services:
        - pandeptwidyaop/proxy-service
    variables:
        HOST: "my-mysql-server.com"
        SSH_USER: "root"
        SSH_KEY_BASE64: $DEV_SSH_BASE64
        PORT: "3306"
    script:
        - cd /var/www/html && php artisan migrate

```
