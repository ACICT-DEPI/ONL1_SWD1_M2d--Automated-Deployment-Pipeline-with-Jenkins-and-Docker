chmod 600 ~/.ssh/pipeline_key.pem
scp -i ~/.ssh/pipeline_key.pem ~/.ssh/pipeline_key.pem ubuntu@$2:/home/ubuntu
ssh -i ~/.ssh/pipeline_key.pem ubuntu@$1 sudo cat /var/lib/jenkins/secrets/initialAdminPassword
ssh -i ~/.ssh/pipeline_key.pem ubuntu@$2 sudo chmod 600 /home/ubuntu/pipeline_key.pem
ssh -i ~/.ssh/pipeline_key.pem ubuntu@$2 sudo chmod 777 /var/run/docker.sock
