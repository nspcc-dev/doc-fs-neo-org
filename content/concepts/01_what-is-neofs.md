---
title: "Introduction"
icon: "ti-blackboard"
description: "Get familiar with basic NeoFS concepts"
type: "docs"
date: "2022-03-01"
weight: 1
---

Here are the basic concepts of NeoFS, the distributed, decentralized object
storage network integrated with the [Neo blockchain](https://neo.org).

The development of blockchain technology has recently moved towards the implementation of corporate and state use to solve specific internal tasks. It is logical to expect the development of decentralized application (DApp) projects in this direction. However, existing decentralized data storage solutions have not yet been fully prepared to meet an emerging need for reliable trusted data storage platform with a secure and controlled integration of corporate and public data storage areas.

Currently, most projects in this field are aimed at implementing simple exclusive storage of
data of some users on capacities of other users or at creating add-ons via IPFS  for implementing public content distribution based on traditional hosting and content delivery network (CDN). Therefore, the niche of storage platform that has a convenient API for DApps and the ability to organize isolated data storage areas with control over data exchange in both public and other private data storage areas is practically empty. It is proposed to solve those problems relying on the Neo Blockchain mechanisms as well as implementing novel approaches in distributed data storage technologies. In this work, we present NeoFS - a distributed decentralized object storage integrated with Neo Blockchain. 

NeoFS is based on a peer-to-peer network that uses information from a smart contracts and Neo Blockchain to coordinate data operations. The storage network keeps the information about its own topology with a history of changes up to date and uses it when placing and searching for data. The applied set of algorithms allows minimizing data movement in the case of changing the network while ensuring the specified storage policies.

NeoFS is aimed at ensuring data availability and integrity. The integrity guarantee is
achieved by using the proposed novel data audit method which is based on homomorphic
hash functions and allows verifying the integrity of data on a storage node without sending real
data to a verifying party over the network. The computational complexity of verification depends
linearly on the size of objects and is well suited for parallelization. This approach not only
reduces the load on the network and storage nodes but also allows avoiding data disclosure to a third
party during a verification phase.

At a lower level, NeoFS provides backward compatibility of a storage format with future
versions of the system. This is important not only for corporate use but also for DApps and
smart contracts that do not have a technical ability to modify codes or reallocate data in the
network. 

Thus, NeoFS should ensure that the need for trusted data storage is met for both public use and various private networks while providing necessary guarantees of information confidentiality, integrity, and availability.
