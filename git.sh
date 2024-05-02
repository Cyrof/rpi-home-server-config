#! /bin/bash

# script for adding, committing, and pushing changes to git repo automatically.

# add all untracked files to the git cache
git add .
echo added untracked files to git cache
sleep 2

# Prompt the user for a commit message if none is provided as a command line argument
read -p "Enter commit messgae (press Enter for default message): " MSG

# if the user didn't enter a message, set a default one
if [ -z "$MSG" ]; then
    MSG="No message"
fi

# commit staged changes with the provided message
git commit -m "$MSG"
echo staged files to git cache
sleep 2

# push changes to the remote repository on github 
echo pushing to github 
git push origin main

# pause to allow user to see any error messages
sleep 3

# clear ther terminal screen
clear
