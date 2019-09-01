echo "Enter userv1:"
read userv1

if [ $userv1 -eq $userv1 2>/dev/null ]; then
    echo "userv1=$userv1"
else
    echo "Non-integer not allowed"
    exit 1
fi

echo "Enter userv2:"
read userv2

if [ $userv2 -eq $userv2 2>/dev/null ]; then
    echo "userv2=$userv2"
else
    echo "Non-integer not allowed"
    exit 1
fi

sum=$((userv1+userv2))
echo "sum:$sum"

mult=$((userv1*userv2))
echo "mult:$mult"

if [ 0 -eq $userv2 2>/dev/null ]; then
    echo "Division by zero error"
    exit 1
else
    div=$((userv1/userv2))
    echo "div:$div"
fi