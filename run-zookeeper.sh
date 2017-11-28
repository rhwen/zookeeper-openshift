#!/bin/bash

set -e

POD_FULLNAME=$(cat /etc/hosts|grep $(cat /etc/hostname)|awk '{print $2}');
POD_HOSTNAME=$(cat /etc/hostname);
NUM_POD_HOSTNAME=${#POD_HOSTNAME};

if [ -z $HOST_PREFIX ]; then
    HOST_PREFIX=$(cut -d "-" -f 1 /etc/hostname);
fi

if [ -z $HOST_POSTFIX ]; then
    HOST_POSTFIX=${POD_FULLNAME:NUM_POD_HOSTNAME};
fi

# Generate the config only if it doesn't exist
if [[ ! -f "$ZOO_CONF_DIR/zoo.cfg" ]]; then
    CONFIG="$ZOO_CONF_DIR/zoo.cfg"

    echo "clientPort=$ZOO_PORT" >> "$CONFIG"
    echo "dataDir=$ZOO_DATA_DIR" >> "$CONFIG"
    echo "dataLogDir=$ZOO_DATA_LOG_DIR" >> "$CONFIG"

    echo "tickTime=$ZOO_TICK_TIME" >> "$CONFIG"
    echo "initLimit=$ZOO_INIT_LIMIT" >> "$CONFIG"
    echo "syncLimit=$ZOO_SYNC_LIMIT" >> "$CONFIG"

    echo "maxClientCnxns=$ZOO_MAX_CLIENT_CNXNS" >> "$CONFIG"

    for ((i=0; i<$ZOO_SERVERS_NUM; i=i+1)); do
        echo "server.$i=$HOST_PREFIX-$i$HOST_POSTFIX:2888:3888" >> "$CONFIG"; 
    done
fi

# Write myid only if it doesn't exist
if [[ ! -f "$ZOO_DATA_DIR/myid" ]]; then
    # echo "${ZOO_MY_ID:-1}" > "$ZOO_DATA_DIR/myid"
    echo "$(cut -d "-" -f 2 /etc/hostname)" > "$ZOO_DATA_DIR/myid"
fi

exec "$@"