chmod 600 ~/.ssh/web_app_key.pem
scp -i ~/.ssh/web_app_key.pem ~/.ssh/web_app_key.pem ubuntu@$2:/home/ubuntu
ssh -i ~/.ssh/web_app_key.pem ubuntu@$1 sudo cat /var/lib/jenkins/secrets/initialAdminPassword
ssh -i ~/.ssh/web_app_key.pem ubuntu@$2 sudo chmod 600 /home/ubuntu/web_app_key.pem
ssh -i ~/.ssh/web_app_key.pem ubuntu@$2 sudo chmod 777 /var/run/docker.sock
