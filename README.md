# PHP Application base container

Included applications
* Supervisor
* Nginx
* PHP-FPM

## Build
```bash
$ docker build -t local/php-app-base .
```

## Run

```bash
$ docker run -it local/php-app-base
```

## Build and run
```bash
$ docker-compose up --build
```
