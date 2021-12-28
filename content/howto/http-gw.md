---
title: "Get your own NeoFS HTTP Gateway"
date: 2021-12-28
---


## Obtain

You can find the gateway [on GitHub](https://github.com/nspcc-dev/neofs-http-gw) and get 
[the latest release](https://github.com/nspcc-dev/neofs-http-gw/releases) in a standard way (single binary). 
However, if you prefer dockerized setup, we have this option covered as well 
[with Docker Hub](https://hub.docker.com/r/nspccdev/neofs-http-gw).


## Run

HTTP gateway is exactly that — just a gateway between HTTP and NeoFS protocol; 
so it relies on NeoFS nodes for data access. It means that you need to provide it 
with NeoFS node address that will be used for request processing. This can be done 
either via -p parameter or via `HTTP_GW_PEERS_<N>_ADDRESS`, `HTTP_GW_PEERS_<N>_WEIGHT` and 
`HTTP_GW_PEERS_<N>_PRIORITY` environment variables (the last two will have `1` value by default). The gateway also supports specifying 
multiple NeoFS nodes with weighted load balancing which can be used for more complex setups.

These two commands are functionally equivalent, they run the gate with 
one backend node from [neofs-dev-env](https://github.com/nspcc-dev/neofs-dev-env):

```
$ neofs-http-gw -p 192.168.130.72:8080
$ HTTP_GW_PEERS_0_ADDRESS=192.168.130.72:8080 neofs-http-gw
```

This is enough to provide you with the read access to public containers via default port `8082`.
Also, you can use specific wallet:

```
$ HTTP_GW_WALLET_PASSPHRASE=password neofs-http-gw -p 192.168.130.72:8080 --wallet /path/to/wallet.json
```


## Access

To get an object via HTTP, you can use `/get/$CID/$OID` path where `$CID` is a container ID and `$OID`
is an object ID. If your cat is stored as `2m8PtaoricLouCn5zE8hAFr3gZEBDCZFe9BEgVJTSocY` in
`J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g` you can obtain it as following

```
$ wget http://localhost:8082/get/J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g/2m8PtaoricLouCn5zE8hAFr3gZEBDCZFe9BEgVJTSocY
```

Yet, sometimes you want to get more user-friendly access, especially if you're developing an
application that needs to take assets from NeoFS and present them to user. You may have lots
of named objects, and you don't always know what their object IDs are. NeoFS objects don't
really have names. Otherwise, they have attributes, and you can set as many attributes for
an object as you wish. Some of them are so-called "well-known" attributes, like `FileName` which
is used to store object's file name. But sky is the limit here! Any kind of string can be an
attribute name, and any kind of string can be its value (beware of HTTP limitations, though,
and try to fit all of this into regular ASCII).

So if you have attributes set for your objects, you can also use
`/get_by_attribute/$CID/$ATTRIBUTE_NAME/$ATTRIBUTE_VALUE` path to get them,
where `$CID` is still a container ID while `$ATTRIBUTE_NAME` and `$ATTRIBUTE_VALUE` are
the name and the value of the attribute you're looking for. The gateway will answer
with the first object matching this name-value pair (technically, there can be multiple
objects matching this criterion).

If your `2m8PtaoricLouCn5zE8hAFr3gZEBDCZFe9BEgVJTSocY` object from the example above has
FileName attribute set to `cat.jpeg` you can get it with the following request:

```
$ wget http://localhost:8082/get_by_attribute/J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g/FileName/cat.jpeg
```

If it has `Ololo` attribute with `100500` value, you can get it this way too:

```
$ wget http://localhost:8082/get_by_attribute/J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g/Ololo/100500
```

### Zip streaming

The gateway supports downloading files by common prefix (like dir) in zip format. You can enable compression
using config or `HTTP_GW_ZIP_COMPRESSION=true` environment variable.

To download some dir (files with the same prefix) in zip use:

```
$ wget http://localhost:8082/zip/J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g/common/prefix
```


## Upload

NeoFS HTTP Protocol Gateway is not just for downloading things from NeoFS, you can also put
new objects via `/upload/$CID` URL where `$CID` is a container ID. FileName attribute is set
automatically in this case based on uploaded file name, but you can also manually add as
many attributes as you like:

```
$ curl -F 'file=@cat.jpeg;filename=cat.jpeg' -H "X-Attribute-Ololo: 100500" http://localhost:8082/upload/J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g
```

You'd get container and object IDs in reply for this request.

This can always be done for public containers that allow anyone to put objects into.
But most probably your dApp containers won't be that permissive and this simple approach
won't work. You will need to explicitly add your gates' keys into container's Extended ACL
rules to allow write access. Using eACL you can also limit access only to the gateways you trust.
You can, of course, provide container owner's keys for HTTP gateway to use,
but that's not really secure, and we don't recommend this approach.

What you can do instead is use delegation mechanism known as Bearer Tokens provided by NeoFS.
This mechanism allows application backend to issue such token, hand it over to the frontend
part (for example, during authentication), and then frontend (like mobile app) to pass it
to the gateway via `Authorization` header or `Bearer` cookie.
Gateway doesn't need anything special then, making it easy to replace gateways/setup new gateways,
it just takes bearer token from the request and passes it along with NeoFS request.
Then NeoFS takes it and does what it's supposed to — reliably stores your kitties.


## Wrap

![http gw wrap scheme](../../images/http-gw-wrap.png)

You may have noticed that the API provided by the gateway natively differs a little from the 
URL scheme given in our previous post. That's because we expect most of the real setups 
to be using some proxy server (or servers) in front of the gateway, providing caching, 
URL rewriting, and TLS termination if needed (although TLS can be handled by the gateway 
itself if needed). For example, in the previous article, we've used nginx as a caching proxy 
with some URL rewriting to make access to objects more web-native.
First, we made direct pass of simple `GET` request to `/get/` location:

```
location  ~ "^/[0-9a-zA-Z]{43,44}/[0-9a-zA-Z\-]{43,44}$" {
  rewrite /(.*) /get/$1 break;
  proxy_pass http://127.0.0.1:8082;
  proxy_cache neofs_cache;
  proxy_cache_methods GET;
}
```
Then, we'd like to have filename-based access to objects:

```
location / {
  rewrite '/([0-9a-zA-Z]{43,44})/(.*)' /get_by_attribute/$1/FileName/$2 break;
  proxy_pass http://127.0.0.1:8082;
  proxy_cache neofs_cache;
  proxy_cache_methods GET;
}
```

And finally, add automatic fallback to index document, to have everything needed 
for decentralized static site hosting on NeoFS:

```
location ~ "^/[0-9a-zA-Z]{43,44}/$" {
  rewrite '/([0-9a-zA-Z]{43,44})/' /get_by_attribute/$1/FileName/index.html break;
  proxy_pass <http://127.0.0.1:8082;>
  proxy_cache neofs_cache;
  proxy_cache_methods GET;
}
```

This thin layer makes accessing NeoFS easier and can accommodate any kind of URL scheme 
you need for your dApp/WebApp or provide compatibility for legacy and third-party components. 
At the same time, it allows you to use proven and well-known solutions for caching and using 
other HTTP-specific features.


## Develop your first decentralized site

Now, we are ready to upload not just a picture, but a real website to store it in a distributed 
and decentralized manner on NeoFS. Create an HTML page `index.html` that will display the 
picture with the hilarious cat.

```
<html>
  <body>
    <h1> Me and my hilarious cat</h1>
    <img src="cat.png">
  </body>
</html>
```

If you upload this file in the NeoFS container storing our `cat.jpg` and set up your nginx by adding location:

```
location /mysite {
    proxy_http_version 1.1;
    proxy_set_header Connection "";
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	rewrite '^/mysite/([0-9a-zA-Z\-]{43,44})$' /get/J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g/$1 break;
    rewrite '^/mysite/$'                     /get_by_attribute/J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g/FileName/index.html break;
    rewrite '^/mysite/([^/]*)$'              /get_by_attribute/J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g/FileName/$1 break;
    rewrite '^/mysite/(.*)$'                 /get_by_attribute/J9VuqGJM16Cx6dxbEtHZtywgYmrHgLAYY3821G1UMY1g/FilePath/$1 break;
    proxy_pass http://localhost:8082;
    proxy_intercept_errors on;
    error_page 404 500 502 503 504 = @fallback;
}

```

You can see the website in: `http://localhost/mysite/index.html`.

The next step is getting dns domain name and set up these components (http-gw and nginx proxy) with tls certs.
As result, you will get truly decentralized website.
