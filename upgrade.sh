#!/bin/bash

source .env

# ---------------------------------------------------------------------------
# Clear screen
# ---------------------------------------------------------------------------
clear

cp -a fabric-latest/* ${PWD}

echo
echo "# ---------------------------------------------------------------------------"
echo "# Stop and upgrade the orderer containers"
echo "# ---------------------------------------------------------------------------"
docker stop orderer.example.com
docker-compose -f docker-compose-orderer.yml up -d --no-deps
sleep 5

echo
echo "# ---------------------------------------------------------------------------"
echo "# Stop the org1 containers."
echo "# Remove chaincode containers and images."
echo "# Upgrade org1 containers."
echo "# ---------------------------------------------------------------------------"
docker stop peer0.org1.example.com
docker stop peer1.org1.example.com
docker stop cli.org1.example.com
if [ "$(docker ps | grep 'example-01')" ]; then
   docker rm -f $(docker ps | grep example-01 | awk '{print $1}') 
fi

if [ "$(docker images | grep 'example-01')" ]; then
   docker image rmi -f $(docker images | grep example-01 | awk '{print $1}')
fi
docker-compose -f docker-compose-org1.yml up -d --no-deps
sleep 5

echo
echo "# ---------------------------------------------------------------------------"
echo "# Upgrade the Org2 containers"
echo "# ---------------------------------------------------------------------------"
docker stop peer0.org2.example.com
docker stop peer1.org2.example.com
docker-compose -f docker-compose-org2.yml up -d --no-deps
sleep 5

echo
echo "# ---------------------------------------------------------------------------"
echo "# List all the containers"
echo "# ---------------------------------------------------------------------------"
docker ps --format "{{.Names}} : {{.Image}} : {{.Status}}" | grep fabric
sleep 5

echo 
echo "# ---------------------------------------------------------------------------"
echo "# Invoking chaincode : Move 10 from A to B"
echo "# ---------------------------------------------------------------------------"
docker exec "$CLI_NAME" peer chaincode invoke -o "$ORDERER_NAME":7050 --tls --cafile $ORDERER_CA_LOCATION -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["move","a","b","10"]}'
sleep 5

echo 
echo "# ---------------------------------------------------------------------------"
echo "# Query chaincode: Query A"
echo "# ---------------------------------------------------------------------------"
docker exec "$CLI_NAME" peer chaincode query -o "$ORDERER_NAME":7050 --tls --cafile $ORDERER_CA_LOCATION -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["query","a"]}'
