#! /bin/bash 
#gambling

win=0
betno=0
totalStock=100
maxwin=150
loss=0
maxloss=50
minbal=$(($totalStock-$maxloss))
totalDaysToPlay=20
dayCount=0
winCountPerDay=0
lostCountPerDay=0

while [ $dayCount -lt $totalDaysToPlay ]
do
	while [ $totalStock -lt $maxwin ] && [ $totalStock -gt $minbal ]
	do
		rno=$(($RANDOM%3))

		if [ $rno -eq 1 ]; then
			win=$(($win+1))
			betno=$(($betno+1))
			totalStock=$(($totalStock+1))
		elif [ $rno -eq 2 ]; then
			betno=$(($betno+1))
			loss=$(($loss+1))
			totalStock=$(($totalStock-1))
		fi
	done
	
	if [ $totalStock -eq 150 ]; then
		echo "day:$(($dayCount+1)) --> you won $win times and loose $loss times || totalbalance = $totalStock|| result : Won"
		winCountPerDay=$(($winCountPerDay+1))
	elif [ $totalStock -eq 50 ]; then
		echo "day:$(($dayCount+1)) --> you won $win times and loose $loss times || totalbalance = $totalStock|| result : Lost"
		lostCountPerDay=$(($lostCountPerDay+1))
	fi
	dayCount=$(($dayCount+1))
	totalStock=100
done

echo "--------------------------------------------------------------------------------------"
echo "This Month -->you won $winCountPerDay times and loose $lostCountPerDay times"
