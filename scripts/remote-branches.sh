#!/usr/bin/env bash
for branch in `git branch -r | grep -v HEAD`; do 
    echo `git show --format="%ci %cr %an" $branch | head -n 1` \\t$branch; 
done | sort -r
