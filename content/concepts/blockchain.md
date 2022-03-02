---
title: NeoFS Blockchain Components 
description: NeoFS Architecture
date: 2022-03-01
weight: 4
---

With the NeoFS release version 0.8, a part of the internal logic of Inner Ring is transferred to Neo blockchain smart contracts, some of which are on the Neo Blockchain main network, some - on the Neo sidechain. 

The main smart contracts that provide the input and output of GAS tokens to the NeoFS account and the list of nodes of Inner Ring, are on the Neo Mainnet. NeoFS internal banking and data audit results are on the sidechain. This allows not to load a large number of NeoFS internal transactions to the Neo blockchain network. This approach also allows us to achieve complete anonymity of the Inner Ring nodes and not to disclose them to other network nodes.

![NeoFS Arch](../../images/arch_05.png)

The main NeoFS network contract is deployed in the Neo main network. The roles of this contract are to maintain the list of the Inner Ring nodes, maintain the list of nodes-candidates for Inner Ring, accept Neo GAS input assets from users, and withdraw Neo GAS to users.

Service contracts of the NeoFS network such as Network Map contract, Container contract, Balance contract, Data Audit contract, and Reputation contract are on the NeoFS Neo sidechain.

The Network Map contract is the main NeoFS network contract in the NeoFS Neo sidechain. The roles of this contract are to provide to the sidechain contracts a list of the Inner Ring nodes, which is initially stored in the Neo main network blockchain in the NeoFS contract, to manage the list of Storage nodes, maintain the Network Map, to take snapshots of Network Map when a new epoch sets, and store the epoch counter, providing an interface for changing the epoch to the Inner Ring nodes. Epoch is a real-time period during which a permanent Network Map exists.

The Container contact is deployed in the NeoFS Neo sidechain. The roles of this contract are to maintain a list of containers and provide such operations as to get a specific container by its identifier, to get a list of all user containers, and to get a list of all containers.

The Balance contact, being in the NeoFS Neo sidechain, provides the internal NeoFS banking performing a large number of fast microtransactions based on the results of the NeoFS network.

The Reputation contract’s role is maintaining reputation ratings of Storage nodes. This contract is also deployed in the NeoFS Neo sidechain to process a lot of invocations to process the view of Storage nodes' trust.

Neo main network chain and NeoFS Neo sidechain do not interact directly. The bridge between the two chains is Inner Ring which subscribes to events from both chains. The Inner Ring nodes are responsible for servicing the Neofs network, monitoring Storage nodes, and data integrity of the storage network.

The Inner Ring nodes are connected to Neo Blockchain. They are constantly monitoring events coming from the blockchain to synchronize their state, the state of the NeoFS smart contract that manages users' GAS deposits and information about the Inner Ring nodes themselves, and NeoFS Neo sidechain smart contracts. 

Since the Inner Ring is a critical infrastructure element, not every node can get this role. The node willing to join  Inner Ring has to be registered in the NeoFS smart contract in Neo Blockchain and pay some security deposit that is lost in case the node starts to behave badly.

In addition, in the same way as Neo consensus nodes, the NeoFS Inner Ring nodes try to achieve maximal possible geographical, political, and network decentralization. 

The Inner Ring nodes monitor the state of Storage nodes. Using this information, they maintain an up-to-date Network Map. It is a multi-dimensional graph where nodes have attributes and are grouped by those attributes and their values. This allows using a special data placement function to find nodes that would store an object when putting or getting it in/from the NeoFS network.

This approach allows not having any centralized meta-data storage keeping object's locations and not re-balancing data with every joining or leaving storage node as it happens in DHT-based systems.

As described in the section “Architecture”, objects are stored in containers in NeoFS.

Each container is served by a subset of storage nodes that satisfy the storage policy defined for this particular container by the user. To calculate that nodes’ subset, storage policy filters are applied to Network Map. The resulting set of nodes is responsible for making sure that the storage policy is satisfied and data is not corrupted. In case of success, they share users' payment for data storage. One storage node may serve many containers, so if it behaves correctly small shares from each container sum-up in a significant reward. The same is true for the losses in case of container nodes' misbehavior. This motivates nodes to keep an eye on other container members and properly perform all required replication, migration, and data recovery processes.

Another non-obvious benefit of this approach is the bigger the NeoFS network grows, the more stable it becomes because the chance of network is changed would affect a particular container is decreasing with the increasing number of nodes in the network. It means, unlike in the DHT approach, the amount of needed data migration decreases with network growth.
