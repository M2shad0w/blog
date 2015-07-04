#!/bin/bash
echo "build at `date`"
cd ~/Documents/gitdoc/blog
git pull
hexo clean
hexo d -g
echo "built successfully"
echo "git blogbackuping"
git add *
git commit -am "blog backup 'date'"
git push origin blogbackup
echo "bolg backup successfully"