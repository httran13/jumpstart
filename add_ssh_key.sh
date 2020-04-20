#@IgnoreInspection BashAddShebang

# Install ssh-agen
which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )

# Run ssh-agent in build
eval $(ssh-agent -s)

echo "$GIT_DEPLOY_KEY" | base64 -d > key.cer
chmod 600 key.cer
ssh-add key.cer

## Create the SSH directory and give it the right permissions
if [ ! -d ~/.ssh ];then
    mkdir -p ~/.ssh
fi
echo $GIT_DEPLOY_KEY | base64 -d > ~/.ssh/id_rsa
chmod 700 ~/.ssh/id_rsa

#Set known hosts
SSH_KNOWN_HOSTS=$(ssh-keyscan $REPO_DOMAIN)
echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts
