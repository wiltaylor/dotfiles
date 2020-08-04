#!/bin/bash

case $1 in
test)
	echo "##SPANRMSG[HIT TEST]##"
	echo "##NOTCONFIGURED##"
	echo test
	;;

apply)
	echo "##SPANRMSG[HIT APPLY]##"
	echo "##NOTCONFIGURED##"
	echo apply
	;;

