# OM Installation(Automation) Script - Quickly setup your lab Ops Manager environment 

# Features

- Install any version of Ops Manager 4.x.x
- Install on any supported Linux Platforms
- Creates a 3 nodes Application Database

## Supported Platforms

- Redhat/Centos
- Amazon
- Ubuntu
- SUSE
- Debian

## Prerequisites

- git :) 
- Make sure your repos are updated(to install other requirements)

## Usage

```
sudo ./om install [--requirements] [--platform=Amazon/Redhat/Centos/Ubuntu/Debian/SUSE]
                  [--config=om-config.json]
            list  [--requirements] [--platform=Amazon/Redhat/Centos/Ubuntu/Debian/SUSE]
                  [--available-platforms] [--version=4.x]
                  [--available-versions]
 ``` 
  

## Installation

```
git clone https://github.com/bhartiroshan/om.git

sudo ./om install --requirements -platform=amazon ## or [redhat/suse/ubuntu/debian]
```

## Create a config file from the template provided

- This creates a om-config.json and updates your hostname in it. 

```
cat om-template-config.json | jq '.mongodProcesses[].servers[0,1,2].hostname = $host' --arg host "$(hostname -f)" >om-config.json
```

## Installing Ops Manager

- Edit om-config.json and change any respective values(e.g. Ops Manager version/AppDB MongoDB version/Platform installing on)

```
{
    "opsManager": [
        {
        "installName":"OM421",
        "version": "4.2.15",
        "platform": "Amazon Linux",
        "package": "tar.gz",
        "userconfig": [
                {
                "firstname": "Ops",
                "lastname": "Manager",
                "login": "testuser@om.com",
                "password": "Opsmanager@123"
                }
        ],
        "backupdaemon": [
                {
                "headdb": "/opt/head",
                "user": "mongodb-mms"
                }
            ]
        }

    ],
    "mongodProcesses": [
        {
            "servers":[
                {
                    "id": "Server01",
                    "port": 27017,
                    "replSetName": "ops-manager-db",
                    "dbPath": "/data/node1",
                    "logpath": "/data/node1/mongodb.log",
                    "hostname": "localhost",
                    "name": "ops-manager-db-1",
                    "featureCompatibilityVersion": "4.2",
                    "version": "4.2.6-ent"
                },
                {
                    "id": "Server02",
                    "port": 27018,
                    "replSetName": "ops-manager-db",
                    "dbPath": "/data/node2",
                    "logpath": "/data/node2/mongodb.log",
                    "hostname": "localhost",
                    "name": "ops-manager-db-2",
                    "featureCompatibilityVersion": "4.2",
                    "version": "4.2.6-ent"
                },
                {
                    "id": "Server03",
                    "port": 27019,
                    "replSetName": "ops-manager-db",
                    "dbPath": "/data/node3",
                    "logpath": "/data/node3/mongodb.log",
                    "hostname": "localhost",
                    "name": "ops-manager-db-3",
                    "featureCompatibilityVersion": "4.2",
                    "version": "4.2.6-ent"
                }
            ]
        }
    ]
}
```

- Install by referencing the om-config.json file

```
sudo ./om install --config=om-config.json 
```
## To list available platforms
```
sudo ./om list --available-platforms # would show for all versions
sudo ./om list --available-platforms --version=4.4 #would only show for 4.4 version
```

