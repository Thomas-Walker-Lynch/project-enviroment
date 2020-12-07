#!/bin/bash

echo "Initializing share"

eval $(ssh-agent)
ssh-add ~/.ssh/twl_github
