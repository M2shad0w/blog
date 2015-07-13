#!/bin/sh
echo "build at `date`"
cd ~/Documents/gitdoc/blog
git pull git@github.com:M2shad0w/m2shad0w.github.io.git blogbackup
hexo clean
hexo d -g
echo "built successfully"
echo "git blogbackuping"
git add *
git commit -am "blog backup 'date'"
git push origin blogbackup
echo "bolg backup successfully"
