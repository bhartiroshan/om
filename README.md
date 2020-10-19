# OM Installation(Automation) Bash Script - Quickly setup your Ops Manager environment 

# Features

- Install any version of Ops Manager 4.x.x
- Upgrade to any 4.x.x version
- Install on any supported Linux Platforms
- Creates a 3 nodes Application Database
- No dependencies other than MongoDB entrprise packages listed in requirements.txt

## Supported Platforms (Tested on Amazon/Centos machines)

- Redhat/Centos
- Amazon
- Ubuntu
- SUSE
- Debian

## Prerequisites

- git :) 
- Make sure your repos are updated(to install other requirements)

## Installation

```
git clone https://github.com/bhartiroshan/om.git

cd om
```

### Install requirements - (Init only first time)

```
sudo ./om init --platform=amazon ## or [redhat/suse/ubuntu/debian]
```
- In some cases where your repos are not updated the packages installation may fail. 
- See the [requirements here](https://github.com/bhartiroshan/om/blob/master/requirements.txt). 

## Usage

```
sudo ./om install [--requirements] [--platform=Amazon/Redhat/Centos/Ubuntu/Debian/SUSE]
                  [--config=CONFIG_FILE_NAME]
            list  [--requirements] [--platform=Amazon/Redhat/Centos/Ubuntu/Debian/SUSE]
                  [--available-platforms] [--version=4.x]
                  [--available-versions]
            init  [--platform=amazon/redhat/suse/ubuntu/debian]
 ``` 

### Installing Ops Manager
 1. Fresh Install(See this section)
 2. [Install by supplying as EC2 startup script](#install-by-supplying-as-ec2-startup-script)
 3. [Upgrade Ops Manager](#upgrade-ops-manager)
 4. [Install multiple versions(co-exist multiple versions](#install-multiple-versionsco-exist-multiple-versions)

- The `init` command installs requirements and generates `om-config.json`, this json you can use for installation purpose.

- Edit om-config.json and change any respective values(e.g. Ops Manager version/AppDB MongoDB version/Platform installing on). Please note that only for package only `tar.gz` is supported so do not change it.

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
                "fsstore":"/opt/snapshot",
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
=====================================================================================================================================
Url to Access and Setup your Ops Manager: http://ec2-13-233-103-91.ap-south-1.compute.amazonaws.com:8080
Username: {username}
Password: {password}
=====================================================================================================================================
A .info file has been placed in /opt/mongodb/OM_Cluster01.info, it has path to binaries to start Application Database or Ops Manager.
{
  "installName": "OM_Cluster01",
  "version": "4.2.15",
  "mmsbin": "/opt/mongodb/mongodb-mms4.2.15/bin/mongodb-mms [start|stop]",
  "appdb_bin": "/opt/mongodb/mongodb-mms-automation/mongodb-mms-automation-agent -pidfilepath /var/log/mongodb-mms-automation-agent.pid -maxLogFileDurationHrs 24 -logLevel INFO -logFile /var/log/mongodb-mms-automation/automation-agent.log -healthCheckFilePath /var/log/mongodb-mms-automation/agent-health-status.json -cluster /opt/mongodb/conf/cluster-config4.2.15.json 2>&1 > /opt/mongodb/mongodb-mms-automation/headless_agent.log &"
}
=====================================================================================================================================
If running OM 4.2.x version then enable Backup Daemon at /opt/head, the Oplog/Blockstore/Filesystem store should be already configured.
No action needed for OM 4.4.x deployments.
=====================================================================================================================================
```
- Please note the user credentials provided in om-config.json for signing in. 
- The backups should be pre-configured. 

### Install by supplying as EC2 startup script
- Use below user data while launching EC2.
- This is tested with t2.large instance type.
```
#!/bin/bash
yum install -y git
git clone https://github.com/bhartiroshan/om.git ~/om
cd ~/om
./om init --platform=amazon
./om install --config=om-config.json --version=4.4.4 --username={username} --password={password}
```
- The version/username/password options are optional, if not supplied the default values from `om-config.json` will be used. 
- Please note that when supplying `version` make sure it's a valid OM Version else script may fail. 
- SSH to the instance and view the progress by tailing below file.
- `tail -f /var/log/cloud-init-output.log`. 

### Upgrade Ops Manager

- Stop existing Ops Manager, see `.info` file for Ops Manager binary.
```
{
  "installName": "OM421",
  "version": "4.4.2",
  "mmsbin": "/opt/mongodb/mongodb-mms4.4.2/bin/mongodb-mms",
  "appdb_bin": "/opt/mongodb/mongodb-mms-automation/mongodb-mms-automation-agent -pidfilepath /var/log/mongodb-mms-automation-agent.pid -maxLogFileDurationHrs 24 -logLevel INFO -logFile /var/log/mongodb-mms-automation/automation-agent.log -healthCheckFilePath /var/log/mongodb-mms-automation/agent-health-status.json -cluster /opt/mongodb/conf/cluster-config4.4.2.json 2>&1 > /opt/mongodb/mongodb-mms-automation/headless_agent.log &"
}
```
- `/opt/mongodb/mongodb-mms4.4.2/bin/mongodb-mms stop`
- Edit `om-config.json` and enter the new(higher) Ops Manager version. 
- Install the new version `sudo ./om install --config=om-config.json`.

### Install multiple versions(co-exist multiple versions)

- Stop existing Ops Manager, see `.info` file for Ops Manager binary.
```
{
  "installName": "OM421",
  "version": "4.4.2",
  "mmsbin": "/opt/mongodb/mongodb-mms4.4.2/bin/mongodb-mms",
  "appdb_bin": "/opt/mongodb/mongodb-mms-automation/mongodb-mms-automation-agent -pidfilepath /var/log/mongodb-mms-automation-agent.pid -maxLogFileDurationHrs 24 -logLevel INFO -logFile /var/log/mongodb-mms-automation/automation-agent.log -healthCheckFilePath /var/log/mongodb-mms-automation/agent-health-status.json -cluster /opt/mongodb/conf/cluster-config4.4.2.json 2>&1 > /opt/mongodb/mongodb-mms-automation/headless_agent.log &"
}
```
- `/opt/mongodb/mongodb-mms4.4.2/bin/mongodb-mms stop`
- Stop existing AppDB `mongod` process, you may use `pkill mongo`.
- Edit `om-config.json` and enter a new AppDB Path/logpath, Install Name and desired OM version.
  - These specs are available under `opsManager.installName`, `opsManager.version`, `mongodProcesses`.`servers[0/1/2].dbPath/logPath`.
```
    "opsManager": [
        {
        "installName":"OM421",
        "version": "4.2.15",
        .
        .
        .
    "mongodProcesses": [
        {
            "servers":[
                {
                    "id": "Server01",
                    "port": 27017,
                    "replSetName": "ops-manager-db",
                    "dbPath": "/data/node1"
```

- Install the new version `sudo ./om install --config=om-config.json`.

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

## Please refer to [MongoDB Licensing](https://www.mongodb.com/community/licensing) for MongoDB Enterprsie usage before using this script. 

