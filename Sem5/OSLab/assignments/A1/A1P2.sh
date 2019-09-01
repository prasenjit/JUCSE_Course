# https://unix.stackexchange.com/questions/50177/birth-is-empty-on-ext4
# https://stackoverflow.com/questions/14842195/how-to-get-file-creation-date-time-in-bash-debian
# getting modification time is possible but creation time is not possible on ext4 filesystem yet

files=( * )
let count=0
let subcount=0
for file in "${files[@]}"; do
    if [[ -d $file ]]; then
        subcount=0
        subfiles=( "$file"/* )
        for subfile in "${subfiles[A]}"; do
            if [[ -f $subfile ]]; then
                subcount=$((subcount+1))
            fi
        done
        echo "$file : $subcount"
        count=$((count+subcount))
    else
        count=$((count+1))
    fi
done
echo "Count : $count"