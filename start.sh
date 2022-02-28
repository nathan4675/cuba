#!/bin/sh
# start xray with URL-config
if [ "${URL_CONFIG}"  ]; then
    /usr/bin/xray -config=${URL_CONFIG} && exit 0
fi

# Set config file if no URL-config
# Set Stream Type
if [ -z "${STREAM_TYPE}"  ]; then
    STREAM_TYPE="ws"
else
    case "${STREAM_TYPE}" in
        tcp)
            STREAM_TYPE="tcp"
            ;;
        http|http2|h2)
            STREAM_TYPE="http2"
            ;;
        *)
            STREAM_TYPE="ws"
            ;;
    esac
fi
cp /usr/local/share/xray/config-${STREAM_TYPE}.json /usr/local/share/xray/config.json && echo "Set STREAM to ${STREAM_TYPE}"

# Set Xray Port
if [ -z "${YOUR_PORT}"  ]; then
    YOUR_PORT=8080
fi
sed -i "s/YOUR_PORT/${YOUR_PORT}/g" /usr/local/share/xray/config.json && echo "Set PORT to /${YOUR_PORT}"

# Set UUID
if [ -z ${YOUR_UUID} ]; then
    YOUR_UUID=`cat /proc/sys/kernel/random/uuid`
fi
sed -i "s/YOUR_UUID/${YOUR_UUID}/g" /usr/local/share/xray/config.json && echo "Set UUID to ${YOUR_UUID}"

# Set Xray Host & Path if streamtype in ws, http2
if [ -z ${YOUR_PATH} ]; then
YOUR_PATH="${YOUR_UUID}-${STREAM_TYPE}"
fi

case "${STREAM_TYPE}" in
    ws)
        sed -i "s/YOUR_PATH/${YOUR_PATH}/g" /usr/local/share/xray/config.json && echo "Set PATH to ${YOUR_PATH}"
        ;;
    http|http2|h2)
        if [ -z ${YOUR_HOST} ]; then
            YOUR_HOST="www.one.com"
        fi
        sed -i "s/YOUR_HOST/${YOUR_HOST}/g" /usr/local/share/xray/config.json && echo "Set HOST to ${YOUR_HOST}"
        sed -i "s/YOUR_PATH/${YOUR_PATH}/g" /usr/local/share/xray/config.json && echo "Set PATH to ${YOUR_PATH}"
        ;;
    *)
        ;;
esac

/usr/bin/xray -config=/usr/local/share/xray/config.json