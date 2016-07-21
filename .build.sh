#!/bin/bash
DATE=`date`
echo "build at $DATE"
local=$pwd
echo $local
# get blog new
git pull git@github.com:M2shad0w/blog.git
echo "wait for ..."
hexo clean
hexo d -g
ret=$?
if [$ret -eq 0 ]
then    
    echo "hexo successfully"
else
    echo "hexo failed"
fi
git add ./source/_posts
git commit -am "blog backup $DATE"
git push blog master
ret=$? 
if [$ret -eq 0 ]
then
    echo "blog backup successfully"
else
    echo "push failed"
fi
