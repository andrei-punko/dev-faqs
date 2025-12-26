# AWS

## AWS course on Udemy
https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/

## Spring AWS documentation
https://docs.awspring.io/spring-cloud-aws/docs/current/reference/html/index.html

## Setup AIM for CodeDeploy:
Create 2 roles: `CodeDeployServiceRole`, `EC2InstanceRoleForCodeDeploy`

## Setup EC2 instance for CodeDeploy:
```
ssh -i /c/Users/Andrei/OneDrive/Configs/aws/aws-admin-key-pair.pem ubuntu@ec2-18-212-3-183.compute-1.amazonaws.com
   3  sudo apt-get update
   4  sudo apt-get install ruby
   5  wget https://aws-codedeploy-eu-west-3.s3.eu-west-3.amazonaws.com/latest/install
   6  chmod +x ./install
   7  sudo ./install auto
   8  sudo service codedeploy-agent status
```

## How to find all Your AWS resources
https://binarybelle.medium.com/how-to-find-all-your-amazon-web-services-resources-5fd818d6503

To see all resources in your AWS Account, not just the ones for the region you’re currently in, go to the AWS Console,
and then choose:
- Choose Services, Resource Groups & Tag Editor, Tag Editor
- From the dropdowns, choose All Regions and All resource types
- Search Resources
- To reduce the results to more relevant resources, I filtered on VPC, Instance, Volume, Bucket, RouteTable and Domain
- Success

## Resize AWS Volume
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html
```
$ df -h
   Filesystem      Size  Used Avail Use% Mounted on
   /dev/nvme0n1p1   30G   28G  1.4G  96% /

$ lsblk
   NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   nvme0n1     259:0    0   33G  0 disk
   --nvme0n1p1 259:1    0   30G  0 part /

$ sudo growpart /dev/nvme0n1 1
   CHANGED: partition=1 start=2048 old: size=62912479 end=62914527 new: size=69203935,end=69205983

$ sudo resize2fs /dev/nvme0n1p1
   resize2fs 1.44.1 (24-Mar-2018)
   Filesystem at /dev/nvme0n1p1 is mounted on /; on-line resizing required
   old_desc_blocks = 4, new_desc_blocks = 5
   The filesystem on /dev/nvme0n1p1 is now 8650491 (4k) blocks long.

$ df -h
   Filesystem      Size  Used Avail Use% Mounted on
   /dev/nvme0n1p1   32G   28G  4.2G  88% /
```

## Get Docker image from ECR
```
aws ecr get-login-password --region [your region] | docker login --username AWS --password-stdin [your aws_account_id].dkr.ecr.[your region].amazonaws.com
```

## Connecting to VM
```
ssh -i aws-admin-key-pair.pem ubuntu@ec2-3-227-21-52.compute-1.amazonaws.com
ssh ubuntu@ec2-3-227-21-52.compute-1.amazonaws.com
<enter-password>
```

## How to enable Password Authentication in AWS EC2 instances
https://www.serverkaka.com/2018/08/enable-password-authentication-aws-ec2-instance.html

1. Login to AWS instance
    ```
    ssh -i your-key.pem username@ip_address
    ```

2. Setup a password for the user using `passwd` command along with the username
    ```
    sudo passwd ubuntu
    ```

3. Edit `sshd_config` file
    ```
    sudo less /etc/ssh/sshd_config
    ```
   Find the Line containing `PasswordAuthentication` parameter and change its value from `no` to `yes`.

   After this changes save file and exit.

4. Restart SSH service
    ```
    service ssh restart              ## for ubuntu
    service sshd restart             ## for centos
    ```

5. Now we can log in using the password you set for the user. For example:
    ```
    ssh ubuntu@ec2-3-227-21-52.compute-1.amazonaws.com
    ```

## Put your key from host machine to avoid providing password each time
```
ssh-copy-id -i ~/.ssh/id_ed25519.pub ubuntu@ec2-3-227-21-52.compute-1.amazonaws.com
```
