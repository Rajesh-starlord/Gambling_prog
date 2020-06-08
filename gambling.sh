#! /bin/bash 
#gambling

win=0
betno=0
totalstock=100
maxwin=150
loss=0
maxloss=50
minbal=$(($totalstock-$maxloss))
while [ $totalstock -lt $maxwin ] && [ $totalstock -gt $minbal ]
do
        rno=$(($RANDOM%3))

        if [ $rno -eq 1 ]; then
            win=$(($win+1))
			betno=$(($betno+1))
			totalstock=$(($totalstock+1))
        elif [ $rno -eq 2 ]; then
     		betno=$(($betno+1))
			loss=$(($loss+1))
            totalstock=$(($totalstock-1))
        fi
done

echo "you won $win times and loose $loss time || totalbalance= $totalstock"
