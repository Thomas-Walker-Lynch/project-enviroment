#!/bin/bash
# this file is in .gitignore so that local only changes may be made

echo "Initializing $1"

# see src/home for the home source code
HOME=$(/usr/local/bin/home)
cd ~/projects/"$1"

#eval $(ssh-agent)
#ssh-add ~/.ssh/key
