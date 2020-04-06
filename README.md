Requirements: 
- terraform version 12 
- python libs : pip install -r requirements.txt  
- OS: ubuntu 16.4 

VPC/EC2
=======
Use terraform to provision the following : 
 - VPC with 2 public subnets and 2 private subnets  spread on 2 availability zones [ a + b ]
 - Network cidr 10.100.1.0/24. 
 - two ec2 instances: vpn-server + ci-server which also acting as the web server via docker container.
 Note: All settings can be easily manipulated via terraform.tfvars

chdir to terraform directory and run: 
```bash
$terraform init && terraform apply 
```
VPN SERVER
==========
hostname/tag: raid-vpn-server. - server is provisioned via ansible using openvpn software. 
Change to vpn/playbooks directory:

```bash
$ansible-playbook -i inventory openvpn_server.yml -u ubuntu 
```

VPN CLIENT
==========
Create vpn clients using ansible. 
navigate to vpn/playbooks directory and run:
```bash
$export targetUser <some-user>
$ansible-playbook -i inventory openvpn_client.yml -u ubuntu
```
Please download openvpn client for your OS: 
- Windows 10 https://swupdate.openvpn.org/community/releases/openvpn-install-2.4.8-I602-Win10.exe
- MacOS : follow this link https://openvpn.net/vpn-server-resources/connecting-to-access-server-with-macos/
- Linux: use your pkg manager 

#client will be created under /tmp directory on the host that is running ansible 

Revoke client: Login to  vpn server and chdir to /etc/openvpn directory 
```bash 
$./revoke.sh <client-name> 
```

JENKINS
==========
hostname/tag: raid-ci-server - nested under the public subnet to allow webhook from github. 
Once connected via the vpn,  you can login to ci server ```http://10.100.1.111:8080```.
Note: creds will be sent via separate email

WEBSITE
==========
hostname/tag: raid-web-server. running simple ningix server 
