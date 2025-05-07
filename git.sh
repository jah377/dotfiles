# Script for setting up git for the first time

echo "Enter user.name:"
read GIT_SETUP_NAME
git config --global user.name $GIT_SETUP_NAME

echo "Enter user.email:"
read GIT_SETUP_EMAIL
git config --global user.email $GIT_SETUP_EMAIL

echo "Now configuring SSH keys..."
ssh-keygen -t rsa -C $GIT_SETUP_EMAIL

echo "Let's start the ssh-agent..."
eval "$(ssh-agent -s)"

echo "Adding SSH key..."
ssh-add ~.ssh/id_rsa

echo "Now copying SSH key to clipboard..."
pbcopy < ~/.ssh/id_rsa.pub
