---
title: "Protocol gateways"
icon: "ti-direction-alt"
description: "NeoFS Protocol gateways, how they work and what they are for"
type : "docs"
date: "2021-12-07"
---

NeoFS provides native [gRPC API](https://github.com/nspcc-dev/neofs-api) and supports the most popular protocols via gateways, allowing easy integration with other systems and applications without requiring significant code rewrite.

Gateways are not proxies, they are more of translating units that take request in some protocol and create a new gRPC requests being a NeoFS client with own keys and identity.
