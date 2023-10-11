---
title: NeoFS Endpoints
description: NeoFS and all related endpoints in N3 Mainnet and N3 Testnet
icon: "ti-link"
type: docs
date: 2021-12-15
---

## NeoFS contract

NeoFS contract deployed in the main chain and used for deposit and withdrawal operations. An initial deposit is required to proceed before any further actions with NeoFS.

{{< tabs >}}
    {{< tab "N3 Mainnet" >}}
        <p>
            <b>Address</b>: NNxVrKjLsRkWsmGgmuNXLcMswtxTGaNQLk
        </p>
        <p style="margin: 0;">
            <b>Script hash</b>: 2cafa46838e8b564468ebd868dcafdd99dce6221
        </p>
    {{< /tab >}}
    {{< tab "N3 Testnet" >}}
        <p>
            <b>Address</b>: NadZ8YfvkddivcFFkztZgfwxZyKf1acpRF
        </p>
        <p style="margin: 0;">
            <b>Script hash</b>: b65d8243ac63983206d17e5221af0653a7266fa1
        </p>
    {{< /tab >}}
{{</ tabs >}}

## Side chain RPC nodes

Storage nodes use side chain nodes to send NeoFS related transactions and listen system-wide events. Transactions are sent via default JSON RPC endpoint, events are delivered through [websocket](https://github.com/nspcc-dev/neo-go/blob/master/docs/rpc.md#websocket-server) connection. 

<!-- todo(alexvanin): Uncomment this tip when side chain protocol files will be available for everyone
{{< notice tip >}}
We highly recommend deploying and using your own side chain RPC node for Storage node. This provides the lowest latency and control over the RPC node failures.
{{< /notice >}}
--> 

{{< tabs >}}
    {{< tab "N3 Mainnet" >}}
        <table style="font-size: 14px">
            <tr>
                <td style="background-color:#ececec"><b>JSON RPC</b></td>
                <td style="background-color:#ececec"><b>Websocket RPC</b></td>
            </tr>
            <tr>
                <td>https://rpc1.morph.fs.neo.org:40341</td>
                <td>wss://rpc1.morph.fs.neo.org:40341/ws</td>
            </tr>
            <tr>
                <td>https://rpc2.morph.fs.neo.org:40341</td>
                <td>wss://rpc2.morph.fs.neo.org:40341/ws</td>
            </tr>
            <tr>
                <td>https://rpc3.morph.fs.neo.org:40341</td>
                <td>wss://rpc3.morph.fs.neo.org:40341/ws</td>
            </tr>
            <tr>
                <td>https://rpc4.morph.fs.neo.org:40341</td>
                <td>wss://rpc4.morph.fs.neo.org:40341/ws</td>
            </tr>
            <tr>
                <td>https://rpc5.morph.fs.neo.org:40341</td>
                <td>wss://rpc5.morph.fs.neo.org:40341/ws</td>
            </tr>
            <tr>
                <td>https://rpc6.morph.fs.neo.org:40341</td>
                <td>wss://rpc6.morph.fs.neo.org:40341/ws</td>
            </tr>
            <tr>
                <td>https://rpc7.morph.fs.neo.org:40341</td>
                <td>wss://rpc7.morph.fs.neo.org:40341/ws</td>
            </tr>
        </table>
    {{< /tab >}}
    {{< tab "N3 Testnet" >}}
        <table style="font-size: 14px">
            <tr>
                <td style="background-color:#ececec"><b>JSON RPC</b></td>
                <td style="background-color:#ececec"><b>Websocket RPC</b></td>
            </tr>
            <tr>
                <td>https://rpc01.morph.testnet.fs.neo.org:51331</td>
                <td>wss://rpc01.morph.testnet.fs.neo.org:51331/ws</td>
            </tr>
            <tr>
                <td>https://rpc02.morph.testnet.fs.neo.org:51331</td>
                <td>wss://rpc02.morph.testnet.fs.neo.org:51331/ws</td>
            </tr>
            <tr>
                <td>https://rpc03.morph.testnet.fs.neo.org:51331</td>
                <td>wss://rpc03.morph.testnet.fs.neo.org:51331/ws</td>
            </tr>
            <tr>
                <td>https://rpc04.morph.testnet.fs.neo.org:51331</td>
                <td>wss://rpc04.morph.testnet.fs.neo.org:51331/ws</td>
            </tr>
            <tr>
                <td>https://rpc05.morph.testnet.fs.neo.org:51331</td>
                <td>wss://rpc05.morph.testnet.fs.neo.org:51331/ws</td>
            </tr>
            <tr>
                <td>https://rpc06.morph.testnet.fs.neo.org:51331</td>
                <td>wss://rpc06.morph.testnet.fs.neo.org:51331/ws</td>
            </tr>
            <tr>
                <td>https://rpc07.morph.testnet.fs.neo.org:51331</td>
                <td>wss://rpc07.morph.testnet.fs.neo.org:51331/ws</td>
            </tr>
        </table>
    {{< /tab >}}
{{</ tabs >}}

## Storage nodes

There are several Storage nodes deployed by NSPCC. Use it to start working with NeoFS and deploy your own nodes for faster and more reliable communication.

{{< tabs >}}
    {{< tab "N3 Mainnet" >}}
        <table style="font-size: 14px">
            <tr>
                <td style="background-color:#ececec"><b>Secured(TLS) endpoint</b></td>
                <td style="background-color:#ececec"><b>Insecure endpoint</b></td>
            </tr>
            <tr>
                <td>grpcs://st1.storage.fs.neo.org:8082</td>
                <td>st1.storage.fs.neo.org:8080</td>
            </tr>
            <tr>
                <td>grpcs://st2.storage.fs.neo.org:8082</td>
                <td>st2.storage.fs.neo.org:8080</td>
            </tr>
            <tr>
                <td>grpcs://st3.storage.fs.neo.org:8082</td>
                <td>st3.storage.fs.neo.org:8080</td>
            </tr>
            <tr>
                <td>grpcs://st4.storage.fs.neo.org:8082</td>
                <td>st4.storage.fs.neo.org:8080</td>
            </tr>
        </table>
    {{< /tab >}}
    {{< tab "N3 Testnet" >}}
        <table style="font-size: 14px">
            <tr>
                <td style="background-color:#ececec"><b>Secured(TLS) endpoint</b></td>
                <td style="background-color:#ececec"><b>Insecure endpoint</b></td>
            </tr>
            <tr>
                <td>grpcs://st01.testnet.fs.neo.org:8082</td>
                <td>st01.testnet.fs.neo.org:8080</td>
            </tr>
            <tr>
                <td>grpcs://st02.testnet.fs.neo.org:8082</td>
                <td>st02.testnet.fs.neo.org:8080</td>
            </tr>
            <tr>
                <td>grpcs://st03.testnet.fs.neo.org:8082</td>
                <td>st03.testnet.fs.neo.org:8080</td>
            </tr>
            <tr>
                <td>grpcs://st04.testnet.fs.neo.org:8082</td>
                <td>st04.testnet.fs.neo.org:8080</td>
            </tr>
        </table>
    {{< /tab >}}
{{</ tabs >}}
