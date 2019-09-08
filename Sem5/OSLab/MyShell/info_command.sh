echo "Filepath: $PWD"/$1
stat --format="File size = %s" $1
stat --format="Last Modification Date & Time = %y" $1
stat --format="Owner = %U" $1
