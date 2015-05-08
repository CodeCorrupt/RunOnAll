#!/bin/bash

# $1 = script to run
# $2 = file with all the connection info

# Format of the input file...
# 
# IP         |Username   |Password
# ---------------------------------
# 10.0.0.1   |thoyt      |P@ssw0rd1

exec 3<$2  # open fd 3 for read
script=$1
while read -u 3 line  # read line from fd 3
do
	my_args=($line)
{
	/usr/bin/expect << EOF
	spawn scp $script "${my_args[1]}\@${my_args[0]}:$script" 
	expect {
		-re ".*es.*o.*" {
			exp_send "yes\r"
			exp_continue
		}
		-re ".*sword.*" {
			exp_send "${my_args[2]}\r"
		}
	}
	expect "$ "
	spawn ssh "${my_args[1]}\@${my_args[0]}"
	expect "assword:"
	exp_send "${my_args[2]}\r"
	expect "$ "
	send "./$script\r"
	expect "$ "
	send "rm $script\r"
	expect "$ "
	send "exit\r"
EOF
}
done
exec 3>&- # close fd 3
