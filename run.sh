#!/bin/bash
if [ ! -f /.mongodb_password_set ]; then
	/set_mongodb_password.sh
fi

if [ "$AUTH" == "yes" ]; then
    export mongodb='/usr/bin/mongod --nojournal --auth --httpinterface --rest --replSet ${MONGODB_REPLICA_SET}'
else
    export mongodb='/usr/bin/mongod --nojournal --httpinterface --rest'
fi

if [ ! -f /data/db/mongod.lock ]; then
    exec $mongodb
else
    export mongodb=$mongodb' --dbpath /data/db' 
    rm /data/db/mongod.lock
    mongod --dbpath /data/db --repair && exec $mongodb
fi

