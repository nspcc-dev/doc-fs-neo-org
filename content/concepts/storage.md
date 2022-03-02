---
title: Data Storage 
description: NeoFS Architecture
date: 2022-03-01
weight: 5
---

To implement data storage and processing, the NeoFS system operates with objects. An object is a structure intended to be placed on a data storage device and transmitted over a network. This structure consists of a user’s data block of a finite length and a set of headers containing information about the data and the object itself. The size of the data in the object can be zero.

Objects may have links to other objects. User data may be split into several linked objects to solve scaling and balancing problems.

There are fixed headers containing the version of the object format, its total length, unique identifier, the optional links to other objects, the signature of a data publisher, type identifier of the next extended headers, and identifiers for internal NeoFS processes.

The extended headers have a similar structure. User data attached to the object is placed after headers.

The object in the system is immutable. The NeoFS core works only with a fixed object header and treats the data as an immutable sequence of bytes without interacting with the content. Extended headers store information about user data properties, encryption algorithms, checksum values, cryptographic signatures, identifiers, etc. Extended headers are processed in the order of appearance by separate data processing and transformation modules. This allows organizing complex schemes of working with information by delegating the processing and conversion of user data to higher-level modules of the system.

The user can define a placement rule and ACL to an owned container. That placement rule is applied to all stored objects. The placement rule consists of a set of SELECT() or FILTER() operations applied to Network Map. The result of these operations is a subgraph of Network Map where data can be placed. The SELECT() operation is applied to a tree. The operation inputs are a replication factor at this level and a bucket type. Multiple operations in the placement rule are put into order and each subsequent SELECT(r, type) operation is applied to the result of the previous one. The FILTER() operation is applied to a graph. The operation inputs are a bucket type, value, and comparison operation. For text values, operations eq, ne are available. For numerical values, gt, ge, lt, and le are additionally available. A set of operations on the graph (in the placement rule) can be combined by using AND, OR, NOT operations. The placement function is executed recursively with the operation of the next step being applied for all the nodes retrieved at the previous step. 

The user can send a request for storage or get of the object to any node of the NeoFS network which will redirect the request to the nodes satisfying the placement rule of the container to which the object belongs.

The NeoFS requests, their structure, and the life cycle are described in the API documentation.

Control over the object's integrity in the container is assigned to Storage nodes of this container. They perform data replication, garbage collection, recovery, and migration. The basis for these actions is the economic model of a collective reward of the container if all data is stored in accordance with the storage policy, or collective fine if it is not.

In addition to monitoring the data integrity, Storage nodes also control access rights to data. NeoFS has a flexible ACL system. It contains the basic ACL written to the container structure, bearer token, and the extended ACL, if it is allowed in the basic ACL, in the container object. The basic ACL is written into the container structure and, as a result, is created together with the container and cannot be changed. Validation of the basic ACL has to be cheap and cover the majority of user needs. In the container structure, this is a 32-bit integer storing a bit field. The extended ACL is stored in the object in the container. It cannot be changed but a new object can be added with a new version which will logically replace previously created objects. In the extended object headers, it is indicated that this is an object of type ExtendedACL and its version. the objects of type ExtendedACL can only be created by the owner of the container because this follows logically from the immutability of the underlying ACL.

If the user, when creating the container, has set the possibility of using the extended ACL, the ExtendedACL object is automatically created with the zero version and an empty access table in the payload section. If an error occurred while trying to get the object with extended ACLs then the authorization check is considered failed. 

The Bearer keyword is used to activate authorization checks on the Bearer token transferred in the request headers. This is a table of the same type as the Extended ACL but with fields indicating the time of the token's validity (with which epoch or height) and a chain of key signatures that goes back to the owner of the container. The Bearer token is processed in the same way as the Extended ACL. If the Bearer token is present in the request then it cancels the check on the Extended ACL.
