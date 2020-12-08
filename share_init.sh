#!/bin/bash
# this file is in .gitignore so that local changes may be made

echo "Initializing share"

# see src/home for the home source code
HOME=$(/usr/local/bin/home)
cd ~/projects/share

#eval $(ssh-agent)
#ssh-add ~/.ssh/key
