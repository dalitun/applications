#!/bin/bash
#
# Starts up a MongoDB replica set
#
# There is a lot of documentation about replica sets:
#
#    http://docs.mongodb.org/manual/reference/replica-configuration/
#    http://docs.mongodb.org/manual/administration/replica-sets/
#
# To read data from a SECONDARY, when in the client, use:
#
#   > rs.slaveOk()
#
# Created by M. Massenzio, 2012-05-10

# Prints usage
function usage {
    echo "Usage: `basename $0` replicaSetName [num] [port] [host]
    
    Creates a replica set of 'num' MongoDB servers, running on consecutive ports
    starting at 'port' on the same 'host' ('localhost' by default).

    By default, it will start 3 servers, on ports {27011, 27012, 27013}.

    Due to bash limited ability to parse command-line args, each argument MUST
    be present, if any of the subsequent ones need to be specified.

    The replicaSetName is required and can be used when connecting to
    the set, using a URI of the form:

        mongodb://host:27011,host:27012,host:27013?replicaSet='replicaSetName'
    "
}

# Creates a replica set member's record for the configuration
#
# Arguments:
#   $1  id
#   $2  host
function create_record {
    echo "{ \"_id\": $1, \"host\": \"$2\"}"
}

# Initialize the replica set
#
# Arguments:
#   $1  primary mongod port (uses global: HOST)
#   $2  replica set configuration record
function initialize_repset {
    if [[ -z "$2" ]]; then
        echo "No configuration record passed"
        exit 1
    fi
    local CFG_REC="$2"
    echo -e "rsconf = ${CFG_REC}\nrs.initiate(rsconf)" | \
        mongo --port $1 --host ${HOST} > /dev/null
}

# Waits for the state of all mongo servers to get past the STARTUP phases
#
# Arguments:
#   $1  a port for the mongo client to connect to (default: 27011)
#   $2  the host to connect to (default: localhost)
function wait_for_repset {
    local PORT=${1:-27011}
    local H=${2:-localhost}
    while true; do
        num=$(echo "rs.status()" | mongo --port $PORT --host $H | grep stateStr | grep -v STARTUP | wc -l)
        if [[ $(expr $num) == ${NUM_REPLICAS} ]]; then
            return
        fi
        sleep 1
    done
}

# Main body of script starts here
# TODO: factor out sub-sections in their own functions

if [[ -z "$1" ]]; then
    usage
    exit 1
fi

declare -r REPSET_NAME="$1"
declare -r NUM_REPLICAS=${2:-3}
declare -r STARTING_PORT=${3:-27011}
declare -r HOST=${4:-localhost}

echo "[INFO] Starting ${NUM_REPLICAS} MongoDB servers on ${HOST}, " \
  " using ports starting at ${STARTING_PORT};" \
  " the replica set will be named: ${REPSET_NAME}"
read -p "Do you want to continue (y/N)? " resp
if [[ $resp != 'y' ]]; then
    echo "Terminating."
    exit 1
fi

if [[ -z ${MONGO_BASE} ]]; then
    echo "[WARN] Please define \$MONGO_BASE to point to where you want data/logs to be created"
    MONGO_BASE=${HOME}/mongod_base
    read -p "Would you like to continue using the default (${MONGO_BASE})? " resp
    if [[ $resp != 'y' ]]; then
        echo "Terminating."
        exit 1
    fi
fi
echo "Using base directory for logs and data: ${MONGO_BASE}"
declare -r LOGS_DIR="${MONGO_BASE}/logs"
declare -r DATA_DIR="${MONGO_BASE}/data"

mkdir -p ${LOGS_DIR}
echo "Logs sent to ${LOGS_DIR}, data saved in ${DATA_DIR}"

if [[ ! -d ${LOGS_DIR} || ! -d ${DATA_DIR} ]]; then
    echo "[ERROR] Either logs or data directory could not be found/created; aborting."
    exit 1
fi

MEMBERS=""
PORT=${STARTING_PORT}
for ((i=1; i <= ${NUM_REPLICAS}; i++))
do
    mkdir -p "${DATA_DIR}/${REPSET_NAME}_${i}"
    LOGPATH="${LOGS_DIR}/${REPSET_NAME}_${i}.log"
    DBPATH="${DATA_DIR}/${REPSET_NAME}_${i}"
    mongod --rest --replSet "${REPSET_NAME}" --logpath $LOGPATH \
        --dbpath $DBPATH --port ${PORT} --fork --vvvvv \
        --smallfiles --oplogSize 128 > /dev/null
    echo "[INFO] MongoDB server started on port $PORT"
    MEMBERS="$MEMBERS $(create_record $i ${HOST}:${PORT})"
    if [[ $i < ${NUM_REPLICAS} ]]; then
        MEMBERS="${MEMBERS},"
    fi
    ((PORT++))
done
CONFIG="{ _id: \"${REPSET_NAME}\", members: [${MEMBERS}]}"
echo "[INFO] Configuring replica set ${REPSET_NAME} and initializing"
initialize_repset ${STARTING_PORT} "${CONFIG}"
if [[ $? != 0 ]]; then
    echo "[ERROR] could not initialize the replica set [${REPSET_NAME}]"
    exit 1
fi
echo "[SUCCESS] Replica set ${REPSET_NAME} started and configured"
echo "[INFO] Waiting for replica set to sync and elect primary..."
wait_for_repset ${STARTING_PORT} ${HOST}
echo "[SUCCESS] To connect to PRIMARY execute: mongo --port ${STARTING_PORT} --host ${HOST}"