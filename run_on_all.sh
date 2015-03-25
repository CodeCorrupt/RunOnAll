#!/bin/bash

# $1 = script to run
# $2 = file with all the connection info

exec 3<$2  # open fd 3 for read
while read -u 3 line  # read line from fd 3
do
	my_args=($line)
	scp_and_run.exp ${my_args[0]} ${my_args[1]} ${my_args[2]} $1
done
exec 3>&- # close fd 3
