# Docker PHP-Nginx

Docker image for modern PHP applications, served using:
- Ubuntu
- Supervisor
- PHP-fpm 7.3
- Nginx

## Configuration

### Timezone

You can configure the timezone of both PHP as Ubuntu by setting the `TIMEZONE` environment variable. By default, the timezone is `UTC`.

### Application root

You can configure the public root (the directory in which your index.php resides) of your application by setting the `APPLICATION_ROOT` environment variable. By default, the application root is `/app`.