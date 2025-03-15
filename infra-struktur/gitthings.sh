#!/bin/bash 

git add . 
read COMMIT
git commit -m "{`$COMMIT`}" 
git push
