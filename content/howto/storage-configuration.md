---
title: Storage node configuration
description: Create basic configuration for a storage node
date: 2022-04-08
weight: 4
---


### NeoFS Administration Utility
The simplest way to configure a storage node is to use [`neofs-adm`](https://github.com/nspcc-dev/neofs-node/blob/master/cmd/neofs-adm/README.md) utility.
Although it has a number of exciting functions, here we only explore the configuration generation command.

#### Prerequisites

1. To work through the guide you should have an N3 wallet. If you don't have one, create it with `neo-go` or `neo-cli`.
2. Every NeoFS node should be visible from the outside, so public IP address must also be present.

#### Initial configuration

The following command will put you in the interactive CLI:
```
$ neofs-adm storage-config
File to write config at [./config.yml]:
```

Firstly, we need to enter the path to the file where the generated configuration should be written.
The default value is given in square brackets. This value can also be overriden by providing a positional argument like this:
```
neofs-adm storage-config /path/to/config.yml
```

Next, we need to enter path to our N3 wallet file and name of the account we would like to use.
```
$ neofs-adm storage-config
...
Path to the storage node wallet: /path/to/your/wallet.json
Wallet account [Nhfg3TbpwogLvDGVvAvqyThbsHgoSUKwtn]:
```
These values can also be provided in the command line via
`--wallet` and `--account` options.

#### GAS deposit

Now, we need to specify the network (currently only mainnet and testnet
are supported) and decide if we want to perform initial GAS deposit.

It's much simpler compared to the way described in the [previous article](./first_step.md#make-a-deposit)!

#### LOCODE configuration
UN-LOCODE is a way to specify locations over the globe.
You can determine your locode given the Country and City here [https://unece.org/trade/cefact/unlocode-code-list-country-and-territory](https://unece.org/trade/cefact/unlocode-code-list-country-and-territory) .

Let's say, I am in Madrid, Spain:
```
UN-LOCODE attribute in [XX YYY] format: ES MAD
```

#### Network


```
Publicly announced address: 1.2.3.4:3456
Resolved IP address: 1.2.3.4
Listening address [127.0.0.1:3456]: 127.0.0.1:3456
Listening address (control endpoint) [127.0.0.1:8090]:
TLS Certificate (optional):
```

Publicly announced address is the address which is advertised to other nodes. It must be publicly
available, so you will get an error for specifying an IP from a private range.

Also, you can optionally specify a TLS certificate to support encrypted
connections.

##### Storage

Finally, you need to decide whether your node is a relay node and provide
a path to be used for storing NeoFS objects.
```
Use node as a relay? yes/[no]: no
Path to the storage directory (all available storage will be used): /tmp
```

##### Final configuration
Congratulations, your node is ready! Run `neofs-node -config c.yml`.

Let's see, what has been generated (details may be different in your case):
```
logger:
  level: info  # logger level: one of "debug", "info" (default), "warn", "error", "dpanic", "panic", "fatal"

node:
  wallet:
    path: /home/neofs-user/.neofs/wallet.json  # path to a NEO wallet; ignored if key is presented
    address: Nhfg3TbpwogLvDGVvAvqyThbsHgoSUKwtn  # address of a NEO account in the wallet; ignored if key is presented
    password: HaRd2gu35SPa5Sw0RD  # password for a NEO account in the wallet; ignored if key is presented
  addresses:  # list of addresses announced by Storage node in the Network map
    - 1.2.3.4:3456
  attribute_0: UN-LOCODE:ES MAD
  relay: false  # start Storage node in relay mode without bootstrapping into the Network map
  subnet:
    exit_zero: false # toggle entrance to zero subnet (overrides corresponding attribute and occurrence in entries)
    entries: [] # list of IDs of subnets to enter in a text format of NeoFS API protocol (overrides corresponding attributes)

grpc:
  num: 1  # total number of listener endpoints
  0:
    endpoint: 127.0.0.1:3456  # endpoint for gRPC server
    tls:
      enabled: false # disable TLS for a gRPC connection

control:
  authorized_keys:  # list of hex-encoded public keys that have rights to use the Control Service
    - 02b3622bf4017bdfe317c58aed5f4c753f206b7db896046fa7d774bbc4bf7f8dc2
  grpc:
    endpoint: 127.0.0.1:8090  # endpoint that is listened by the Control Service

morph:
  dial_timeout: 20s  # timeout for side chain NEO RPC client connection
  disable_cache: false  # use TTL cache for side chain GET operations
  rpc_endpoint:  # side chain N3 RPC endpoints
    - https://rpc01.morph.testnet.fs.neo.org:51331
    - https://rpc02.morph.testnet.fs.neo.org:51331
    - https://rpc03.morph.testnet.fs.neo.org:51331
    - https://rpc04.morph.testnet.fs.neo.org:51331
    - https://rpc05.morph.testnet.fs.neo.org:51331
    - https://rpc06.morph.testnet.fs.neo.org:51331
    - https://rpc07.morph.testnet.fs.neo.org:51331
  notification_endpoint:  # side chain N3 RPC notification endpoints
    - wss://rpc01.morph.testnet.fs.neo.org:51331/ws
    - wss://rpc02.morph.testnet.fs.neo.org:51331/ws
    - wss://rpc03.morph.testnet.fs.neo.org:51331/ws
    - wss://rpc04.morph.testnet.fs.neo.org:51331/ws
    - wss://rpc05.morph.testnet.fs.neo.org:51331/ws
    - wss://rpc06.morph.testnet.fs.neo.org:51331/ws
    - wss://rpc07.morph.testnet.fs.neo.org:51331/ws

storage:
  shard_pool_size: 15  # size of per-shard worker pools used for PUT operations
  shard_num: 1  # total number of shards

  default: # section with the default shard parameters
    metabase:
      perm: 0644  # permissions for metabase files(directories: +x for current user and group)

    blobstor:
      perm: 0644  # permissions for blobstor files(directories: +x for current user and group)
      depth: 2  # max depth of object tree storage in FS
      small_object_size: 102400  # 100KiB, size threshold for "small" objects which are stored in key-value DB, not in FS, bytes
      compress: true  # turn on/off Zstandard compression (level 3) of stored objects
      compression_exclude_content_types:
        - audio/*
        - video/*

      blobovnicza:
        size: 1073741824  # approximate size limit of single blobovnicza instance, total size will be: size*width^(depth+1), bytes
        depth: 1  # max depth of object tree storage in key-value DB
        width: 4   # max width of object tree storage in key-value DB
        opened_cache_capacity: 50  # maximum number of opened database files

    gc:
      remover_batch_size: 200  # number of objects to be removed by the garbage collector
      remover_sleep_interval: 5m  # frequency of the garbage collector invocation

  shard:
    0:
      mode: "read-write"  # mode of the shard, must be one of the: "read-write" (default), "read-only"

      metabase:
        path: /path/to/storage/meta  # path to the metabase

      blobstor:
        path: /path/to/storage/blob  # path to the blobstor
```

The generated file is documented so you can tweak all other settings yourself.
Good luck!
