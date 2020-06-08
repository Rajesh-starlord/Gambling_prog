#! /bin/bash
#gambling

win=0
betno=0
totalstock=100
maxwin=150
loss=0
maxloss=50
minbal=$(($totalstock-$maxloss))

rno=$(($RANDOM%3))

if [ $rno -eq 1 ]; then
	echo "you won"
	win=$(($win+1))
	totalstock=$(($totalstock+1))
elif [ $rno -eq 2 ]; then
	echo "you lost"
	loss=$(($loss+1))
	totalstock=$(($totalstock-1))
fi


