# OM Installation(Automation) Bash Script - Quickly setup your Ops Manager environment 

# Features

- Install any version of Ops Manager 4.x.x
- Upgrade to any 4.x.x version
- Install on any supported Linux Platforms
- Creates a 3 nodes Application Database
- No dependencies other than MongoDB entrprise packages listed in requirements.txt

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
                  [--config=CONFIG_FILE_NAME]
            list  [--requirements] [--platform=Amazon/Redhat/Centos/Ubuntu/Debian/SUSE]
                  [--available-platforms] [--version=4.x]
                  [--available-versions]
 ``` 
  

## Installation

```
git clone https://github.com/bhartiroshan/om.git

cd om
```

### Install requirements

```
sudo ./om install --requirements --platform=amazon ## or [redhat/suse/ubuntu/debian]
```
- See the [requirements here](https://github.com/bhartiroshan/om/blob/master/requirements.txt). 
- In some cases where your repos are not updated these packages installation may fail. 

### Generate a config file from the template provided

- This creates a om-config.json and updates your hostname in it. 

```
cat om-template-config.json | jq '.mongodProcesses[].servers[0,1,2].hostname = $host' --arg host "$(hostname -f)" >om-config.json
```

### Installing Ops Manager

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

############################################
Starting Automation Agent in Headless Mode:
############################################
Waiting for mongod processes to be in healthy state.                         Currently 0 processes up.                         Sleeping for 05 Seconds: Sorry!
Waiting for mongod processes to be in healthy state.                         Currently 0 processes up.                         Sleeping for 05 Seconds: Sorry!
Waiting for mongod processes to be in healthy state.                         Currently 0 processes up.                         Sleeping for 05 Seconds: Sorry!
Waiting for mongod processes to be in healthy state.                         Currently 0 processes up.                         Sleeping for 05 Seconds: Sorry!

MongoDB Processes are in healthy State, preparing to download Ops Manager:

################################################
Download URL for Ops Manager from: https://downloads.mongodb.com/on-prem-mms/tar/mongodb-mms-4.2.14.56911.20200603T2241Z-1.x86_64.tar.gz
################################################
The require version /opt/mongodb/mongodb-mms4.2.14 already exists, skipping downloading it.
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    50  100    50    0     0  50000      0 --:--:-- --:--:-- --:--:-- 50000
###################################################################################
Starting Ops Manager 4.2.14 from bin location /opt/mongodb/mongodb-mms4.2.14/bin/mongodb-mms
###################################################################################
Starting pre-flight checks
Successfully finished pre-flight checks

Migrate Ops Manager data
   Running migrations...                                   [  OK  ]
Starting Ops Manager server
   Instance 0 starting.................                    [  OK  ]
Starting pre-flight checks
Successfully finished pre-flight checks

Start Backup Daemon...                                     [  OK  ]
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   859  100   698  100   161    973    224 --:--:-- --:--:-- --:--:--  1196
```
- After successful installation you will see metadata and URL to access your Ops Manager.

```
User created successfully.
Url to Access your Ops Manager: http://example.com:8080
A .info file has been placed in /opt/mongodb/OM4214.info, it has path to binaries to start Application Database or Ops Manager.
{
  "installName": "OM4214",
  "version": "4.2.14",
  "mmsbin": "/opt/mongodb/mongodb-mms4.2.14/bin/mongodb-mms",
  "appdb_bin": "/opt/mongodb/mongodb-mms-automation/mongodb-mms-automation-agent -pidfilepath /var/log/mongodb-mms-automation-agent.pid -maxLogFileDurationHrs 24 -logLevel INFO -logFile /var/log/mongodb-mms-automation/automation-agent.log -healthCheckFilePath /var/log/mongodb-mms-automation/agent-health-status.json -cluster /opt/mongodb/conf/cluster-config4.2.14.json 2>&1 > /opt/mongodb/mongodb-mms-automation/headless_agent.log &"
}
```
- Please note the user creadentisl provided in om-config.json for signing in. 
- After successful login create Organization. 

## To list available platforms
```
sudo ./om list --available-platforms # would show for all versions
```
```
sudo ./om list --available-platforms --version=4.4 #would only show for 4.4 version
4.4
[
  "4.4.0",
  "Debian 9, 10 / Ubuntu 16.04 + 18.04",
  "Red Hat + CentOS 6, 7, 8 / SUSE 12 + 15 / Amazon Linux 2",
  "Microsoft Windows Server 2012 R2, 2016 + 2019",
  "Red Hat 7 (ppc64le)"
]
[
  "4.4.0",
  "Debian 9, 10 / Ubuntu 16.04 + 18.04",
  "Red Hat + CentOS 6, 7, 8 / SUSE 12 + 15 / Amazon Linux 2",
  "Microsoft Windows Server 2012 R2, 2016 + 2019",
  "Red Hat 7 (ppc64le)"
]
```

