# docker-interactivebroker-gateway
Dockerized InteractiveBroker Gateway

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
 Default VNC password is `1234` ¯\_(ツ)_/¯ ...

Shutting down the InteractiveBroker Gateway container:
```
docker-compose down
```
