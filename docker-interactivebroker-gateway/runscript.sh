#!/bin/bash

function create_config_jts {
# Environemnt variables
# JTS_DEBUG=false
# JTS_TIMEZONE=America/Chicago
# JTS_TRADING_MODE=p
# JTS_REMOTE_HOST_ORDER_ROUTING=cdc1.ibllc.com
# JTS_SUPPORT_SSL=gdc1.ibllc.com:4000,true,20190909,false;zdc1.ibllc.com:4000,true,20190912,false
# JTS_USE_SSL=true
# JTS_REGION=us
# JTS_PEER=zdc1.ibllc.com:4001

    cat <<EOF > $1
[IBGateway]
WriteDebug=${JTS_DEBUG:-false}
TrustedIPs=127.0.0.1
MainWindow.Height=550
RemoteHostOrderRouting=${JTS_REMOTE_HOST_ORDER_ROUTING:-cdc1.ibllc.com}
RemotePortOrderRouting=4000
LocalServerPort=4000
ApiOnly=true
MainWindow.Width=700

[Logon]
useRemoteSettings=false
TimeZone=${JTS_TIMEZONE:-America/Chicago}
Individual=1
FontSize=15
tradingMode=${JTS_TRADING_MODE:-p}
colorPalletName=dark
Steps=8
Locale=en
SupportsSSL=${JTS_SUPPORT_SSL:-gdc1.ibllc.com:4000,true,20190909,false;zdc1.ibllc.com:4000,true,20190912,false}
UseSSL=${JTS_USE_SSL:-true}
os_titlebar=false
s3store=true

[ns]
darykq=1

[Communication]
SettingsDir=/root/Jts
Peer=${JTS_PEER:-zdc1.ibllc.com:4001}
Region=${JTS_REGION:-us}

EOF

}

function create_config_ib_controller {
# Environemnt variables
#IBC_LOG:-yes
#IBC_LOG:-no
#IBC_TRADING_MODE:-paper
#IBC_EXISTING_SESSION_DETECTED_ACTION:-primary
#IBC_SHOW_ALL_TRADES:-no
#IBC_FORCE_TWS_API_PORT:-4001
#IBC_CLOSE_DOWN_AT
#IBC_AUTO_CLOSE_DOWN:-yes
#IBC_ALLOW_BLIND_TRADING:-no
#IBC_DISMISS_PASSWORD_EXPIRY_WARNING:-no
#IBC_PORT:-7462

    cat <<EOF > $1
LogToConsole=${IBC_LOG:-yes}
FIX=${IBC_LOG:-no}
PasswordEncrypted=no
TradingMode=${IBC_TRADING_MODE:-paper}
IbDir=
StoreSettingsOnServer=no
MinimizeMainWindow=no
ExistingSessionDetectedAction=${IBC_EXISTING_SESSION_DETECTED_ACTION:-primary}
AcceptIncomingConnectionAction=accept
ShowAllTrades=${IBC_SHOW_ALL_TRADES:-no}
ForceTwsApiPort=${IBC_FORCE_TWS_API_PORT:-4001}
ReadOnlyLogin=no
AcceptNonBrokerageAccountWarning=yes
ClosedownAt=${IBC_CLOSE_DOWN_AT}
IbAutoClosedown=${IBC_AUTO_CLOSE_DOWN:-yes}
AllowBlindTrading=${IBC_ALLOW_BLIND_TRADING:-no}
DismissPasswordExpiryWarning=${IBC_DISMISS_PASSWORD_EXPIRY_WARNING:-no}
DismissNSEComplianceNotice=yes
SaveTwsSettingsAt=
IbControllerPort=${IBC_PORT:-7462}
IbControlFrom=
IbBindAddress=
CommandPrompt=
SuppressInfoMessages=yes
LogComponents=never
Region=

EOF

}

create_config_jts /root/Jts/jts.ini
create_config_ib_controller /root/IBController/IBController.ini

export TWS_MAJOR_VRSN=974
export IBC_INI=/root/IBController/IBController.ini
export IBC_PATH=/opt/IBController
export TWS_PATH=/root/Jts
export TWS_CONFIG_PATH=/root/Jts
export LOG_PATH=/opt/IBController/Logs
export JAVA_PATH=/opt/i4j_jres/1.8.0_152/bin # JRE is bundled starting with TWS 952
export APP=GATEWAY

xvfb-daemon-run /opt/IBController/Scripts/DisplayBannerAndLaunch.sh &
# Tail latest in log dir
sleep 1
tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) &

echo 
echo ---- JTS config ----
cat /root/Jts/jts.ini

echo ---- IBController config ----
cat  /root/IBController/IBController.ini

echo

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
sleep 30
echo "Forking :::4001 onto 0.0.0.0:4003"
socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001
