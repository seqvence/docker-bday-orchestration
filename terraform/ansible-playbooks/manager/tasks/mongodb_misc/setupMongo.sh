#!/bin/bash

echo "Clone git repository"
git clone https://5add9ecdab5aebd839ac6c1f18668fb8817f28c9@github.com/seqvence/docker-bday-orchestration.git \
/root/docker-bday-orchestration

echo "Change permissions  and ownership for mongo-key"
chmod 600 /root/docker-bday-orchestration/mongodb_misc/mongoKey/mongodb-keyfile
chown 999.999 /root/docker-bday-orchestration/mongodb_misc/mongoKey/mongodb-keyfile

echo "Create external volume for MongoDb: /data/db"
mkdir -p /data/db

if [ $1 == "dbm0i.do.lab.seqvence.com" ]; then
echo "Start mongo container with no authentication"
docker run --name $1 \
-v /data/db:/data/db \
-v /root/docker-bday-orchestration/mongodb_misc/mongoKey:/opt/keyfile \
--hostname="$1" \
-p 27017:27017 \
-d mongo:latest --smallfiles

sleep 5;

echo "Add users dba_admin and dba_root"
docker exec -i $1 mongo --host localhost admin <<EOF
use admin;
db.createUser( {
     user: "dba_admin",
     pwd: "E5g8mOxH2gKTuduW",
     roles: [ { role: "userAdminAnyDatabase", db: "admin" },
              { role: "readWrite", db: "dockerBirthday" }
            ]
   });


db.createUser( {
     user: "dba_root",
     pwd: "k6nMtV3KiYoFiV1R",
     roles: [ { role: "root", db: "admin" } ]
   });
exit;
EOF

echo "Stop and remove $1 Container"
docker stop dbm0i.do.lab.seqvence.com | xargs docker rm

echo "Starting the final container of MongoDB"
docker run \
--name $1 \
-v /data/db:/data/db \
-v /root/docker-bday-orchestration/mongodb_misc/mongoKey:/opt/keyfile \
--hostname="$1" \
--label="traefik.enable=false" \
-p 27017:27017 -d mongo:latest \
--smallfiles \
--keyFile /opt/keyfile/mongodb-keyfile \
--replSet "rsdb"

sleep 5;

echo "Initialize replicaSet"
docker exec -i $1 mongo --host localhost admin <<EOF
use admin;
db.auth("dba_root", "k6nMtV3KiYoFiV1R");
rs.initiate();
rs.status();
use dockerBirthday;
db.submissions.createIndex({coordinates: 1});
db.submissions.createIndex({_id: 1, status: 1})
exit;
EOF

else

echo "Starting the final container of MongoDB"
docker run \
--name $1 \
-v /data/db:/data/db \
-v /root/docker-bday-orchestration/mongodb_misc/mongoKey:/opt/keyfile \
--hostname="$1" \
--label="traefik.enable=false" \
-p 27017:27017 -d mongo:latest \
--smallfiles \
--keyFile /opt/keyfile/mongodb-keyfile \
--replSet "rsdb"

sleep 5;

docker exec -i $1 mongo --host dbm0i.do.lab.seqvence.com admin <<EOF
use admin;
db.auth("dba_root", "k6nMtV3KiYoFiV1R");
rs.add("$1")
rs.status();
exit;
EOF

fi