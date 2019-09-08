while true; do
	echo ">"
	read command
	
	arr=()
	i=0
	for word in $command; do
		arr[i]=$word
		i=$((i+1))
	done

	if [[ ${arr[0]} == "exitnewshell" ]]; then
		exit 0

	elif [[ ${arr[0]} == "editfile" ]]; then
		if [[ ${#arr[@]} -gt 1 ]]; then
			filename=${arr[1]}
			vi $filename
		else
			vi
		fi

	elif [[ ${arr[0]} == "dirnew" ]]; then
		if [[ ${#arr[@]} -gt 1 ]]; then
			foldername=${arr[1]}
			mkdir $foldername
		else
			echo "No foldername specified"
		fi

	elif [[ ${arr[0]} == "info" ]]; then
		if [[ ${#arr[@]} -gt 1 ]]; then
			filename=${arr[1]}
			echo "Filepath: $PWD"/$filename
			stat --format="File size = %s" $filename
			stat --format="Last Modification Date & Time = %y" $filename
			stat --format="Owner = %U" $filename
		else
			echo "No filename specified"
		fi
	fi

done
