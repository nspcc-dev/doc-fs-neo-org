---
title: ACL for Dummies
description: Create and set eACL
date: 2022-02-02
---

### Create Container with Basic ACL

Any user wants to be in control of their data. To share the photos of their cute kitties with the whole world or to keep some private pictures private. Simple way to solve the problem in NeoFS is Basic ACL – just set the container holding your objects as `public-read`, `public-read-write` or `private`. 

The issues emerge when one wants to add to the restrictions. Here comes extended ACL. Note that eACL never cancels Deny rules already stated in the relevant Basic ACL. It can only extend prohibiting rules. Neither can you set any extended ACL if `--basic-acl` for the created container is stated as in the paragraph above. If you feel like adding extra rules to the container in future, set `--basic-acl` as `eacl-private`, `eacl-public-read` or `eacl-public-read-write`.

### Set first eACL

Let’s take a Public Container (“0x1FFFFF”) where anyone can do anything: get range, get range hash, search, delete, put, head, and get objects. For some reason, you as the owner of this container wishes to prevent others from deleting objects therefrom. This should be written as a rule in a JSON file, which looks as follows (separately or as a part of the full rules list)

```
{
   "records":
      {
         "operation":"DELETE",
         "action":"DENY",
         "targets":[
            {
               "role":"OTHERS"
            }
         ]
      }
}
```
Although it can be written manually, we have introduced a special command for `neofs-cli acl`. Now, with `neofs-cli acl extended create` you can create a JSON file consisting of any rules in a more user-friendly manner. Set the container’s ID with `--cid` flag and then state all the rules you need for the container with `-r` flag. In the case above, your command should be

```BashSession
neofs-cli acl extended create --cid <container’s ID> -r “deny delete others” --out table.json
```

Here you state the action (which is either `deny` or `allow`), the operation affected by the action, and the target i.e. the user or a group of users for whom this operation is denied/allowed.

Set it using the following command 

```BashSession
neofs-cli --rpc-endpoint <remote node address> -w <container owner’s wallet> container set-eacl --cid <CID> --table <path to JSON file with eACL> --await
```

Now, all users can still do anything but deleting.

### Change eACL and set new

Some time passes, and the user understands that it’s absolutely ok if everyone could delete objects. But there is one specific object that should not be got by a specific user. Now a new eACL is to be generated. It will absolutely replace previous eACL. 
First, state explicitly that `DELETE` is again allowed for `OTHERS`. This time, however, let’s write this rule in a separate file. E.g. `rule.txt` containing `allow delete others`.

Then, the interesting part begins. If one wants to deny an operation over certain objects, filters should be written in the JSON file. Choose the object attribute (e.g. objectID in this case) and decide if the operation over objects holding this attribute is to be denied/allowed. 
As a result, we use the command bellow (available since [neofs-cli v0.27.5](https://github.com/nspcc-dev/neofs-node/releases/tag/v0.27.5))

```BashSession
neofs-cli acl extended create --cid <container’s ID> --file rule.txt -r “deny get obj:objectID=<OID> pubkey:<PubKey>”  --out table.json
```

Check the example below to see what the resulting JSON should look like

```
{
   "records": [
      {
         "operation":"DELETE",
         "action":"ALLOW",
         "targets":[
            {
               "role":"OTHERS"
            }
         ]
      },

    {
         "operation":"GET",
         "action":"DENY",
         "filters": [{"headerType": "OBJECT", "matchType": "STRING_EQUAL", "key": "$Object:objectID", "value": "<OID>"}],
         "targets":[
            {
               "role":"USER"
	   "keys":["<PublicKey* represented as Base64>"]   
            }
         ]
      }
    ]
}

```
Here we settle that for a certain user `GET` is denied for the object whose OID is equal to the one defined. 

Do not forget to set these new rules with `neofs-cli container set-eacl`.

### Details and Recommendations

Note that now we only provide strict equality or inequality(`=` or `!=`).

In total, you can use 9 object filters:
- version
- objectID
- containerID
- ownerID
- creationEpoch
- payloadLength
- payloadHash
- objectType
- homomorphicHash

Though, in most user scenarios, 2 of them will be quite enough: objectID and ownerID.

We do not recommend to deny certain operation with some object filters, since undefined behaviour is expected. For the full list of combinations, check the table (`+` means allowed to be used and `-` means undefined behaviour, hence not allowed)
| $Object:        | GET | HEAD | PUT | DELETE | SEARCH | RANGE | RANGEHASH |
|-----------------|:---:|:----:|:---:|:------:|:------:|:-----:|:---------:|
| version         | +   | +    | +   | -      | -      | -     | -         |
| objectID        | +   | +    | +   | +      | -      | +     | +         |
| containerID     | +   | +    | +   | +      | +      | +     | +         |
| ownerID         | +   | +    | +   | -      | -      | -     | -         |
| creationEpoch   | +   | +    | +   | -      | -      | -     | -         |
| payloadLength   | +   | +    | +   | -      | -      | -     | -         |
| payloadHash     | +   | +    | +   | -      | -      | -     | -         |
| objectType      | +   | +    | +   | -      | -      | -     | -         |
| homomorphicHash | +   | +    | +   | -      | -      | -     | -         |
| User headers    | +   | +    | +   | -      | -      | -     | -         |

Also remember that some operations are interdependent. For instance, `DELETE` and `RANGE` operations need to produce `HEAD` requests upon execution. Therefore, if you deny `HEAD`, expect `DELETE` and `RANGE` to fail. The full table of spawning object requests is given below.
| Base/Gen | PUT | DELETE | HEAD | RANGE | GET | HASH | SEARCH |
|----------|:---:|:------:|:----:|:-----:|:---:|:----:|:------:|
| PUT      | +   | -      | -    | -     | -   | -    | -      |
| DELETE   | +   | -      | +    | -     | -   | -    | +      |
| HEAD     | -   | -      | +    | -     | -   | -    | -      |
| RANGE    | -   | -      | +    | +     | -   | -    | -      |
| GET      | -   | -      | +    | -     | +   | -    | -      |
| HASH     | -   | -      | +    | +     | -   | -    | -      |
| SEARCH   | -   | -      | -    | -     | -   | -    | +      |
 
For more details about `acl extended create` commands use `--help` flag.


### Way to go!

Now, you see how to be truely in control of your data in NeoFS. Follow the instruction above and manage access to your files. Create eACL's to deny (or allow) certain operations to certain groups of users. Feel free to change your mind and generate new eACL's according to your new life circumstances. Just don't forget to set them anew!

```BashSession
neofs-cli acl extended create --cid <container’s ID> -f rules.txt -r “deny get others” --out table.json
neofs-cli --rpc-endpoint <remote node address> -w <container owner’s wallet> container set-eacl --cid <CID> --table <path to JSON file with eACL> --await
```


\* PublicKey can be found with the following commands:
```BashSession
neo-go wallet dump-keys -w <wallet>` or `neofs-cli util keyer <wif>
```
