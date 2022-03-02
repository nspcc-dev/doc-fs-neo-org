---
title: Integration with Neo 3.0 
description: NeoFS Architecture
date: 2022-03-01
weight: 3
---

The integration of NeoFS and Neo 3.0 is implemented in both direct and indirect ways.

Direct integration:

 * Allows Neo smart contracts to get and put objects to NeoFS directly from the contract code using calls to Neo Oracles
 * Adds NeoFS operations to NeoGUI and neo-cli
 * Creates additional Neo Applications to work with NeoFS

Indirect way:

 * Identifies users for data storage and accounting using Neo wallets 
 * Uses (when available) NeoID as a certification system based on the X.509 PKI for ACLs
 * Uses (when available) NeoID for Storage Nodes attributes claims
 * Uses Neo smart contract for deposit and withdrawal operations paying with GAS
 * Uses Neo3 as sidechain for internal operations

API library in C# and Golang is provided as the main integration tool. This allows working with the NeoFS network from any application in those languages. In addition, the implementation of the API library for any language is a relatively simple task due to the use of the gRPC protocol and ProtoBuf definitions of all data structures.

While it is easy to implement a public data retrieval, we plan to leverage simplified PKI using NeoID to delegate write permissions to smart contracts using certificate signing chains. This approach allows simplifying the logic of deposit/withdrawal of assets for NeoFS.
