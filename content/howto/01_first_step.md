---
title: First steps in NeoFS Testnet
description: Upload first NeoFS object
date: 2021-12-28
---


### Create Wallet

First of all, you need to create a wallet and request N3 Testnet GAS tokens.

* Get Neo-Go (will be used here). Neo-Go’s latest releases are available [here](https://github.com/nspcc-dev/neo-go/releases).  All wallet-related actions can be done with other wallet apps, [here](https://neo.org/neogas#wallets) you can find more information.

```BashSession
$ wget https://github.com/nspcc-dev/neo-go/releases/download/v0.98.0/neo-go-linux-amd64 -O neo-go

$ chmod +x neo-go

$ ./neo-go --version
neo-go version 0.98.0
```

* Create N3 wallet and check your address.


```BashSession
$ neo-go wallet init -w new_wallet.json -a
Enter the name of the account > NeoFS first experience
Enter passphrase > 
Confirm passphrase > 

{
 	"version": "3.0",
 	"accounts": [
 		{
 			"address": "NYSRF7zzSQjroLAHR7fkDToPpfeV3gaYHM",
 			"key": "6PYP6VCm2q6Sknr2zb9PhWUFT5vHSg2nvRzqRTxhX7UGXXBhGE1BrZnSFo",
 			"label": "NeoFS first experience",
 			"contract": {
 				"script": "DCEDU69C1umk1zg25fDwOUA59E/zxvuYZu6rO88xxvuXOCdBdHR2qg==",
 				"parameters": [
 					{
 						"name": "parameter0",
 						"type": "Signature"
 					}
 				],
 				"deployed": false
 			},
 			"lock": false,
 			"isdefault": false
 		}
 	],
 	"scrypt": {
 		"n": 16384,
 		"r": 8,
 		"p": 8
 	},
 	"extra": {
 		"Tokens": null
 	}
 }

wallet successfully created, file location is new_wallet.json
 
```

* To get wallet address and public key, you can use such command as:
```BashSession
$ neo-go wallet dump-keys -w new_wallet.json
```

Now you can request N3 Testnet GAS via the NGD N3 TestNet faucet.
1. Open [NEO3 Testnet Faucet](https://neowish.ngd.network/neo3/) and request GAS
2. Check your address [here](https://neo3.testnet.neotube.io/address/NYSRF7zzSQjroLAHR7fkDToPpfeV3gaYHM) to see that everything is done correctly
 

![N3 Testnet GAS balance](../../images/first_step_1.png)

### Make a Deposit

To make a deposit to the NeoFS account, execute the `transfer` method to the NeoFS Smart Contract address.

```
neo-go wallet nep17 transfer -w {wallet} -r {NEO_ENDPOINT} --from {address} --to {NEOFS_CONTRACT_ADDRESS} --token GAS --amount {amount}
```

* {wallet} — path to your N3 wallet
* {address} — N3 address
* {NEO_ENDPOINT} — any N3 node (e.g., https://rpc1.n3.nspcc.ru:20331)
* {NEOFS_CONTRACT_ADDRESS} — NeoFS contract address is NadZ8YfvkddivcFFkztZgfwxZyKf1acpRF in the current N3 Testnet version
* {amount} — number of gas tokens to add to the NeoFS balance

Let’s see the example for our wallet:
```BashSession
$ neo-go wallet nep17 transfer -w wallet.json -r https://rpc1.n3.nspcc.ru:20331 --from NYSRF7zzSQjroLAHR7fkDToPpfeV3gaYHM --to NadZ8YfvkddivcFFkztZgfwxZyKf1acpRF --token GAS --amount 100
Password > 
b6f933035e0c5f0c8e7817e9a1f786121d07ab2ee657fcc0f7b550fa3d81583c
```

Now, look at your N3 balance:
![N3 Testnet GAS balance](../../images/first_step_2.png)

As you see, we have transferred 100 GAS + network fee for a smart contract calling.

### Check NeoFS balance

To work with NeoFS, install NeoFS CLI.
Get it binary from the latest release [here](https://github.com/nspcc-dev/neofs-node/releases).

```BashSession
$ wget https://github.com/nspcc-dev/neofs-node/releases/download/v0.27.0/neofs-cli-amd64 -O neofs-cli
chmod +x neofs-cli
```

To get NeoFS balance, execute the command below

```
neofs-cli -r {NEOFS_ENDPOINT} -w wallet.json accounting balance
```

* {NEOFS_ENDPOINT} — any NeoFS node (e.g., st01.testnet.fs.neo.org:8080)

For example:

```BashSession
$ neofs-cli --rpc-endpoint st01.testnet.fs.neo.org:8080 -w wallet.json accounting balance 
Enter password > 
106.00173390
```

### Create your first container

In NeoFS, users put their data into Containers. Containers are like folders in a file system or buckets in Amazon’s S3 but with Storage Policy attached. Storage Policy is set up by the user and defines how objects in this container should be stored.

The policy can use nodes attributes as follows, “Store data in three different countries on two different continents in three copies on nodes with SSD disks and good reputation.” Storage nodes will do their best to keep data in accordance with this policy. Otherwise, they will not get paid for their service.

To create a container, one has to set Storage Policy via neofs-cli command. For now, we will give a simple example of storing several copies of data on random storage nodes. For instance, to store an object in 3 copies, we should declare such policy as `REP 3`. 

On testnet, anyone can easily add and kill their own node, as this network is designed for testing and development. Therefore, we recommend for the first time to create a container with the storage rule `'REP 2 IN X CBF 2 SELECT 2 FROM F AS X FILTER "Deployed" EQ "NSPCC" AS F'`. Such placement policy stores objects on nodes which are deployed by NeoSPCC.

There are several predefined basic Access Control Lists (ACL): 
- private,
- public-read,
- public-read-write.
In a public container, everyone can read and write objects to the container; in a private container, only the owner of the container can execute read and write operations. In a read-only container, only the owner can write to the container, but anyone can read data from it. In our example, we will use predefined public-read basic ACL. 

To do it, we should execute neofs-cli command as follows:

```
neofs-cli -r {NEOFS_ENDPOINT} -w wallet.json container create --policy 'REP 2 IN X CBF 2 SELECT 2 FROM F AS X FILTER "Deployed" EQ "NSPCC" AS F' --basic-acl public-read --await
```

```BashSession
$ neofs-cli -r st01.testnet.fs.neo.org:8080 -w wallet.json container create --policy 'REP 2 IN X CBF 2 SELECT 2 FROM F AS X FILTER "Deployed" EQ "NSPCC" AS F' --basic-acl public-read --await
Enter password > 
container ID: Ec1fAsQbstaVbUHboEEgtFNguCpyBKfTqhcV7NmjVSoJ
awaiting...
container has been persisted on sidechain
```

It can take some time to process transaction on N3 Testnet.

Container ID for your data is `Ec1fAsQbstaVbUHboEEgtFNguCpyBKfTqhcV7NmjVSoJ`. 

Once the container is created, we can upload data to the NeoFS network.

### Upload a cat to NeoFS

To put the object in our container, we should execute the neofs-cli command. 

We can also add some user headers to the object to run search operations by specific filters in the future. 

We want to set `content_tag` as `cat` and `my_attr` as `cute`.

```BashSession
neofs-cli -r {NEOFS_ENDPOINT} -w wallet.json object put --file {FILE_PATH} --cid {CONTAINER_ID} --attributes content_tag=cat,my_attr=cute
```

```BashSession
$ neofs-cli -r st01.testnet.fs.neo.org:8080 -w wallet.json object put --file cat.png --cid Ec1fAsQbstaVbUHboEEgtFNguCpyBKfTqhcV7NmjVSoJ --attributes content_tag=cat,my_attr=cute
Enter password > 
[cat.png] 
Object successfully stored
 ID: 9VbUbR6mGqFU1RdcUR1xUJZpyrPejvVT8fwxtDNCP5xQ
 CID: Ec1fAsQbstaVbUHboEEgtFNguCpyBKfTqhcV7NmjVSoJ

```

### Get your cat or share it with friends

To get the object, you can use the command with either any key (in case of public container) or an owner key (in case of private container):

```
neofs-cli {NEOFS_ENDPOINT} -w wallet.json object get --cid {CONTAINER_ID} --oid {OBJECT_ID} --file {PATH_TO_FILE}
```

### Search for objects with some specific attributes in the container

To run search operation you can use different filters by meta information of the objects. For example, you can filter objects by attributes declared in the previous steps:

```BashSession
$ neofs-cli -r st01.testnet.fs.neo.org:8080 -w wallet.json object search --cid Ec1fAsQbstaVbUHboEEgtFNguCpyBKfTqhcV7NmjVSoJ --filters 'img_type EQ cat' --filters 'my_attr EQ cute'
Enter password > 
Found 1 objects.
9VbUbR6mGqFU1RdcUR1xUJZpyrPejvVT8fwxtDNCP5xQ
```
