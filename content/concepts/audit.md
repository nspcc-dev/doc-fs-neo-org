---
title: Data Audit 
description: NeoFS Architecture
date: 2022-03-01
weight: 6
---

In the case of a large number of objects in a distributed network of untrusted nodes with an ever-changing topology, the classical approach with comparing objects' hashes with some sample in a central meta-data storage is not efficient. This causes unacceptable overhead.

To solve this problem, NeoFS uses Homomorphic hashing. It is a special type of hashing algorithms that allows computing the hash of a composite block from the hashes of individual blocks.

For integrity checks, NeoFS calculates a composite homomorphic hash of all the objects in a group under control and puts it into a structure called Storage Group. During integrity checks, NeoFS nodes can ensure that hashes of stored objects are correct and a part of that initially created composite hash. This can be done without moving the object's data over the network and no matter how many objects are in Storage Group, the hash size is the same.

Each epoch, Inner Ring nodes perform a data audit. It is a two-stage game in terms of game theory. At the first stage, nodes in the selected container are asked to collectively reconstruct a list of homomorphic hashes that form a composite hash stored in Storage Group. By doing that, nodes demonstrate that they have all objects and are able to provide a hash of those objects. The provided list of hashes can be validated, but at the current stage, it is unknown, if some nodes are lying.

![NeoFS Arch](../../images/arch_06.png)

At the second stage, it is necessary to make sure that nodes are honest and do not fake check results. The Inner Ring nodes calculate a set of nodes’ pairs that store the same object and ask each node to provide thee homomorphic hashes of that object. Ranges are chosen in a way that the hash of a range asked from one node is the composite hash of ranges asked from another node in that pair. Nodes cannot predict objects or ranges that are chosen for audit. They cannot even predict a pair node for the game. This stage discovers malicious nodes fast because each node is serving multiple containers and Storage Groups and participates in many data audit sessions. When a node is caught in a lie it will not get any rewards for this epoch. So the price of faking checks and risks are too high and it is easier and cheaper for the node to be honest and behave correctly.

Combining the fact of nodes being able to reconstruct the Storage Group's composite hash and the fact of nodes honest behavior, the system can consider that the data is safely stored, not corrupted, and available with a high probability.

In the case of a successful data audit result, the Inner Ring nodes initiate microtransactions between the accounts of the data owner and the owner of the storage node invoking the smart contract in the NeoFS Neo sidechain.
