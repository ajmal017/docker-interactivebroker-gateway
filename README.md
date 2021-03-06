
# docker-interactivebroker-gateway #

## Dockerized InteractiveBroker Gateway ##

REQUIREMENTS - You will need to create the following file in order to authenticate with InteractiveBroker Gateway (see the sample `docker-compose.yml` config file below for an example):

File                  | Description
-------------------   | -------------------------------------
secrets.conf          | The username/password of your InteractiveBroker account

Find below a sample docker-compose.yml file that you can use in order to run a dockerized InteractiveBroker Gateway instance:
```
version: '3.7'

services:
  tws:
    image: interactivebroker-gateway
    build: docker-interactivebroker-gateway

    env_file:
      # The file below contains the InteractiveBroker <username> and <password> variables.
      # Make sure not to insert spaces around the equals sign:
      #
      # TWSUSERID=<username>
      # TWSPASSWORD=<password>
      # Or if using FIX:
      # FIXUSERID=
      # FIXPASSWORD=
      #
      - ./secrets.conf

    ports:
      # Gateway API connection
      - "4003:4003"
      # VNC
      - "5901:5900"

    environment:
      - TZ=America/Chicago
      - VNC_PASSWORD=1234 # CHANGE ME (or not)
      - TRADING_MODE=paper # either paper or live

```

The following command will build the InteractiveBroker Gateway image:
```
docker-compose build
```
At this stage make sure you have a file named `secrets.conf` (default name) under current directory, which contains the InteractiveBroker login information:

```
TWSUSERID=<username>
TWSPASSWORD=<password>
# Or if using FIX:
# FIXUSERID=
# FIXPASSWORD=
```

Starting InteractiveBroker Gateway as a container:
```
docker-compose up
```

The container completes the startup process by displaying following line (assuming default ports are used):

```
tws_1  | Forking :::4001 onto 0.0.0.0:4003
```

You can inspect the running Gateway at any time using VNC on `127.0.0.1:5901` (assuming default port is used).
 Default VNC password is `1234` ... `¯\_(ツ)_/¯` 

Shutting down the InteractiveBroker Gateway container:
```
docker-compose down
```
