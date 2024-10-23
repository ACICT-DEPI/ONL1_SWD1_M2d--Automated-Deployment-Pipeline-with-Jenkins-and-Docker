chmod 400 ~/.ssh/pipeline_key.pem
# run the playbooks for jenkins agent and master
ansible-playbook -i ../jenkins-master.ini master-playbook.yml --private-key ~/.ssh/pipeline_key.pem --ssh-extra-args="-o StrictHostKeyChecking=no"
ansible-playbook -i ../jenkins-agent.ini agent-playbook.yml --private-key ~/.ssh/pipeline_key.pem --ssh-extra-args="-o StrictHostKeyChecking=no"
# get the initialAdminPassword for jenkins
ssh -i ~/.ssh/pipeline_key.pem ubuntu@$(cat ../jenkins-master.ini) sudo cat /var/lib/jenkins/secrets/initialAdminPassword


