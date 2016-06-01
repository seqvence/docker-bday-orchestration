database = {
    "hostname": "dbm0i.do.lab.seqvence.com",
    "portNo": "27017",
    "database": "dockerBirthday",
    "collection": "submissions",
    "replicaSet": "rsdb",
    "username": "dba_admin",
    "password": "E5g8mOxH2gKTuduW"
}

docker = {
    "api": "tcp://dbm0i.do.lab.seqvence.com:2375",
    "network": "swarm_network"
}

container = {
    "api_port": "80",
    "api_path": "/getconfig",
    "default_message": '{"name":"Gordon","twitter":"@docker","location":"San Francisco, CA, USA",' \
                       '"repo":["example/examplevotingapp_worker","example/examplevotingapp_voting-app",' \
                       '"example/examplevotingapp_result-app"],"vote":"Cats"}'
}
twitter = {
    "tweet_message": "Just completed the #dockerbday challenge!"
                     " Built, shipped & ran my first app using "
                     "@docker: docker.party #learndocker #docker",
    "tweet_link": "https://twitter.com/intent/tweet?text="
}

consul = {
    "host": "172.17.0.1",
    "port": "8500",
    "key": "docker/swarm/leader"
}
