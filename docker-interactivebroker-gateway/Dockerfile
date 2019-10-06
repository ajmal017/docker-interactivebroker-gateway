FROM ubuntu:18.04

LABEL maintainer="Christophe Alexandre <chris.perso@gmail.com>"

RUN  apt-get update \
  && apt-get install -y unzip \
  && apt-get install -y xvfb \
  && apt-get install -y libxtst6 \
  && apt-get install -y libxrender1 \
  && apt-get install -y libxi6 \
	&& apt-get install -y x11vnc \
  && apt-get install -y socat \
  && apt-get install -y software-properties-common

# Setup IB TWS
RUN mkdir -p /opt/TWS
WORKDIR /opt/TWS

# Setup  IBController
RUN mkdir -p /opt/IBController/Logs && mkdir -p /root/IBController/Logs

WORKDIR /opt/IBController/
ADD ./IBController-QuantConnect-3.2.0.5.zip /opt/IBController/IBController-QuantConnect-3.2.0.5.zip 
RUN unzip ./IBController-QuantConnect-3.2.0.5.zip

ADD ./ibgateway-latest-standalone-linux-x64-v974.4g.sh /opt/TWS/ibgateway-latest-standalone-linux-x64-v974.4g.sh
RUN chmod a+x /opt/TWS/ibgateway-latest-standalone-linux-x64-v974.4g.sh
RUN chmod -R u+x *.sh && chmod -R u+x Scripts/*.sh

# Install TWS
RUN yes n | /opt/TWS/ibgateway-latest-standalone-linux-x64-v974.4g.sh

WORKDIR /

ENV DISPLAY :0

ADD runscript.sh runscript.sh
ADD ./vnc-config/xvfb_init /etc/init.d/xvfb
ADD ./vnc-config/vnc_init /etc/init.d/vnc
ADD ./vnc-config/xvfb-daemon-run /usr/bin/xvfb-daemon-run

RUN chmod -R u+x runscript.sh \
  && chmod -R 777 /usr/bin/xvfb-daemon-run \
  && chmod 777 /etc/init.d/xvfb \
  && chmod 777 /etc/init.d/vnc

CMD bash runscript.sh
