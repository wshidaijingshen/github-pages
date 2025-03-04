# ssh private key 
```
ssh-keygen -t rsa -C 'comments' -f /home/your_name/.ssh/custom_id_rsa
ssh-add ~/.ssh/custom_id_rsa

# add pub to github ssh keys,then test

ssh -T git@github.com

# Use SSH for Git Operations
cd existing_repo
git remote set-url origin git@github.com:username/repo.git
```
