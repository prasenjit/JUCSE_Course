if [ $# -gt 0 ]
then
	echo "Filename: $1"
	echo "Block Count : $(stat --printf "%b" $1)"
else
	echo "No filename specified"
fi
