#!/bin/sh

echo "Hello     World"  # echo with one argument
echo Hello     World    # echo with two arguments, while printing to console, will be space separated
echo "Hello  W" "orld"  # echo with two arguments

echo Hello * World
echo "Hello  "*" world"
echo `Hello` world
echo 'Hello' world
echo "Hello" world

MSG="Hello\" World"
echo $MSG

echo "Enter val1:"
read VAL1
echo "Enter val2:"
read VAL2
expr $VAL1 + $VAL2

echo "Enter filename"
read FILENAME
touch $FILENAME

ls
rm $FILENAME
ls