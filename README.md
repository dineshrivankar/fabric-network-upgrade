## Fabric Network Upgrade 
This tutorial will help to upgrade the Fabric network component.

### Installation Guide
Kindly install all the [Prerequisites](https://hyperledger-fabric.readthedocs.io/en/release-1.4/prereqs.html) mentioned on the official documentation. Make sure we have all the Docker Images downloaded locally.
For exploration, take a VM with 16GB and 4 vCPU.

**# Step 1**

Clone the git repository on VM as below.

```bash
    git clone https://github.com/dineshrivankar/fabric-network-upgrade.git
```

**# Step 2**


Generate Crypto material for all the participants and Deploy the peers by running the below script. For exploration we will use Solo mode for the Ordering service

```bash
     ./deploy.sh
```
After successful deployment, we will find the below containers. Note, all the containers are deployed with Image 1.3.0
```bash
     peer0.org2.example.com : hyperledger/fabric-peer:1.3.0    : Up 5 seconds
     peer1.org2.example.com : hyperledger/fabric-peer:1.3.0    : Up 3 seconds
     cli.org1.example.com   : hyperledger/fabric-tools:1.3.0   : Up 10 seconds
     peer1.org1.example.com : hyperledger/fabric-peer:1.3.0    : Up 15 seconds
     peer0.org1.example.com : hyperledger/fabric-peer:1.3.0    : Up 19 seconds
     orderer.example.com    : hyperledger/fabric-orderer:1.3.0 : Up 25 seconds
```

**# Step 3**

Org1 runs a cli container, below script will create a channel, join all the peers to the channel, install & instantiate chaincode, invoke & query chaincode.


```bash
     ./run.sh
```

**# Step 4**
Network component upgrade will follow the below process, kindly note that we need to upgrade component in liner fashion. 
1.	Stop the orderer / peer.
2.	Back up the orderer’s / peer’s ledger and MSP.
3.	Remove chaincode containers and images (Only for peer’s).
4.	Restart the orderer / peer with latest image.
5.	Verify upgrade completion.

We are using persistent data store for each container, therefore we will skip the backup process.
```bash
    // Orderer container
    - /var/mynetwork/orderer.example.com:/var/hyperledger/production/orderer
    
    // Peer0 org1 container 
    - /var/mynetwork/peer0.org1.example.com:/var/hyperledger/production
    
    // Peer1 org1 container 
    - /var/mynetwork/peer1.org1.example.com:/var/hyperledger/production
    
    // Peer0 org2 container 
    - /var/mynetwork/peer0.org2.example.com:/var/hyperledger/production
    
    // Peer1 org2 container 
    - /var/mynetwork/peer1.org2.example.com:/var/hyperledger/production
```

Upgrade the network component with below script.

```bash
     ./upgrade.sh
```
After completion of the script, we will see below output. All the container are upgraded from image 1.3.0 to latest.
```bash
    peer0.org2.example.com : hyperledger/fabric-peer:latest    : Up 5 seconds
    peer1.org2.example.com : hyperledger/fabric-peer:latest    : Up 5 seconds
    cli.org1.example.com   : hyperledger/fabric-tools:latest   : Up 17 seconds
    peer1.org1.example.com : hyperledger/fabric-peer:latest    : Up 18 seconds
    peer0.org1.example.com : hyperledger/fabric-peer:latest    : Up 19 seconds
    orderer.example.com    : hyperledger/fabric-orderer:latest : Up 32 seconds
```

**# Step 5**

Reset the network by running below script.

```bash
     ./reset.sh 
```


That’s it!

Feel free to submit a PR.