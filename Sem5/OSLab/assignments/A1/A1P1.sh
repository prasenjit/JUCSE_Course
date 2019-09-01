while true
do
    echo "========================================"
    echo "Enter userv1:"
    read userv1

    if [ $userv1 -eq $userv1 2>/dev/null ]; then
        echo "  userv1=$userv1"
    else
        echo "*** Non-integer not allowed, Exiting ***"
        exit 1
    fi

    echo "Enter userv2:"
    read userv2

    if [ $userv2 -eq $userv2 2>/dev/null ]; then
        echo "  userv2=$userv2"
    else
        echo "*** Non-integer not allowed, Exiting ***"
        exit 1
    fi

    sum=$((userv1+userv2))
    echo "SUM : $sum"

    mult=$((userv1*userv2))
    echo "MULTIPLICATION : $mult"

    if [ 0 -eq $userv2 2>/dev/null ]; then
        echo "*** Division by zero error, Exiting ***"
        exit 1
    else
        div=$((userv1/userv2))
        echo "DIVISION : $div"
    fi

    echo "Want to try again? y/n :"
    read again
    if [ "$again" == "n" ]; then
        exit 1
    fi
done