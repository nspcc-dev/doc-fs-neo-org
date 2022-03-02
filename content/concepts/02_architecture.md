---
title: Architecture
description: NeoFS Architecture
date: 2022-03-01
weight: 2
---

NeoFS relies on Neo Blockchain and its features. This allows NeoFS nodes to concentrate on their primary tasks - 
data storage, and processing, and leave assets management and distributed system coordination to Neo and a set of 
smart contracts.

![NeoFS Arch](../../images/arch_01.png)

There are two types of NeoFS nodes: Storage nodes and Inner Ring nodes.

The first type is responsible for receiving data from the user reliably storing it according to storage policy and providing access to the data according to access control lists (ACL). Storage nodes are coordinated with smart contracts.

The second type does not store user data. Inner Ring nodes monitor the NeoFS network health, calculate Storage nodes reputation ratings, and perform data audit giving out penalties and bounties depending on the audit results.

![NeoFS Arch](../../images/arch_02.png)

Each Storage node in the system has a set of key-value attributes describing node properties such as geographical location, reputation rating, number of replicas, number of nodes, presence of SSD drives, etc. Inner Ring nodes generate Network Map - multi-graph structure allowing to group and select Storage nodes based on those attributes. 

In NeoFS, the user puts files in a container. The container is similar to a folder in a file system or a bucket in Amazon S3 but with an storage policy attached. Storage Policy is defined by the user in SQL-like language (NetmapQL) and tells how and where objects in the container have to be stored by selecting nodes by their attributes. Storage nodes keep data in accordance with the policy, or otherwise, they do not get paid for their service.

All storage nodes service fees are paid in GAS (Neo’s utility token). The user may own storage nodes and receive GAS, but at the same time spend that GAS on paying for storage of his/her backups on other NeoFS nodes in the network or other services of the Neo Blockchain program ecosystem.

NeoFS utilizes Network Map, storage policy, a novel data audit method, and economic incentives giving users an opportunity to have control over his/her data. The user defines where and how the data has to be stored and who can have access to it without trusting any third-party service or company.

An innovative feature of NeoFS is its accessibility directly from NeoVM on the smart contract code level. Due to the Neo 3.0 Oracles protocol and integration between NeoFS and Neo Blockchain, dApps are not limited to on-chain storage and can manipulate large amounts of data without paying a prohibitive price.

NeoFS has a native gRPC API and support of popular protocol gates allowing integration with other systems and applications without rewriting their code.

Having such an architecture, it becomes possible to implement dApp's smart contract to manage digital assets and data access permissions on NeoFS and let users access that data using regular Web Browser or mobile application.

![N3 Testnet GAS balance](../../images/arch_04.png)

In the long term, more ecosystem components will be added that will allow developing truly decentralized applications solving almost any problems that are nowadays solved in a centralized manner.



