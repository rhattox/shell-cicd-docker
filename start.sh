#env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-swarm.yml teste
