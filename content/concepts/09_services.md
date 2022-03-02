---
title: NeoFS Services
description: NeoFS Architecture
date: 2022-03-01
weight: 9
---

NeoFS consists of core and external services. The core is responsible for storing objects and performs the necessary minimum of operations with objects and data.
External services can implement any additional logic of data pre- or post-processing, provide an advanced API, or convert requests from any users' required format in the NeoFS API.

Virtually any application can be implemented based on the NeoFS core with external services, for example:
 * S3/Swift Gates for the ability to work with s3/swift frontend using NeoFS backend;
 * POSIX-like pseudo File Systems; 
 * Encryption/Decryption service for private data;
 * non-realtime streaming video/audio service;
 * HTTP Gates for retrieving data from NeoFS in web applications;
 * storing the websites themselves and open them through plugins for the web-servers;

The division of NeoFS into the core and external services allows the use of a public storage to adapt it for any projects and requirements from developers and users or any changes in IT and legal spheres.
