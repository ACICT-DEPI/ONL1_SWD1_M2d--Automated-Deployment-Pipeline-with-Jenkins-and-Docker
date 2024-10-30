
1. terraform (make sure the inventory.ini is clean)
```
cd terraform
terraform init
terraform plan
terraform apply
```
2. run the ansible configuration script 
```bash
cd  ansible-monfiguration-management 
bash ./ansible-cmd.sh
```
3. configure jenkins
	- Credentials 
	- agent node
	- github webhook
	- email notification
	- pipeline
4. build the pipeline manually or though a commit to the repo
