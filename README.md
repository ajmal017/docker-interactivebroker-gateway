# docker-interactivebroker-gateway
Dockerized InteractiveBroker Gateway

Find below  sample docker-compose.yml file that you can use in order to run a dockerized InteractiveBroker Gateway instance:
```
version: '3.7'

services:
  tws:
    image: interactivebroker-gateway:v974
    build: docker-interactivebroker-gateway

    # The file below contains the InteractiveBroker <username> and <password> variables.
    # Make sure not to insert spaces around the equals sign:
    # 
    # TWSUSERID=<username>
    # TWSPASSWORD=<password>
    #
    env_file:
      - ./secrets.conf

    ports:
      - "4003:4003"
      - "5901:5900"

    volumes:
      - ./docker-interactivebroker-gateway/ib-config/IBController.ini:/root/IBController/IBController.ini
      - ./docker-interactivebroker-gateway/ib-config/jts.ini:/root/Jts/jts.ini

    environment:
      - TZ=America/Chicago
      # Variables pulled from /IBController/IBControllerGatewayStart.sh
      - VNC_PASSWORD=1234 # CHANGE ME
      - TWS_MAJOR_VRSN=974
      - IBC_INI=/root/IBController/IBController.ini
      - IBC_PATH=/opt/IBController
      - TWS_PATH=/root/Jts
      - TWS_CONFIG_PATH=/root/Jts
      - LOG_PATH=/opt/IBController/Logs
      - JAVA_PATH=/opt/i4j_jres/1.8.0_152/bin # JRE is bundled starting with TWS 952
      - TRADING_MODE=paper # either paper or live
      - FIXUSERID=
      - FIXPASSWORD=
      - APP=GATEWAY

```

The following command will build the InteractiveBroker Gateway image:
```
docker-compose build
```
At this stage make sure you have a file named `secrets.conf` (default name) under current directory, which contains the InteractiveBroker login information:

```
TWSUSERID=<username>
TWSPASSWORD=<password>
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
