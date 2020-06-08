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
declare -a resultOftheDay
declare -a winfrequency
declare -a lostfrequency

count=0
frequency=0
function calfrequency(){
	for (( i=count;i<20;i++ ))
	do	
		if [[ ${resultOftheDay[i]} == $1 ]] && [ $i -ne 19 ];
		then
			frequency=$(($frequency+1))
		elif [[ ${resultOftheDay[i]} != $1 ]];
		then
			if [ $frequency -ne 0 ];
			then
				if [[ $1 == "Won" ]];
				then
					winfrequency[$i]="startDay:$(($count+1))-wfrequency:$frequency"
				elif [[ $1 == "Lost" ]];
				then
					lostfrequency[$i]="startDay:$(($count+1))-lfrequency:$frequency"
				fi
			fi
			count=$(($i+1))
			frequency=0

		elif  [ $i -eq 19 ];
		then
			if [[ $1 == "Won" ]];
			then
				winfrequency[$i]="startDay:$(($count+1))-wfrequency:$(($frequency+1))"
			elif [[ $1 == "Lost" ]];
			then
				lostfrequency[$i]="startDay:$(($count+1))-lfrequency:$(($frequency+1))"
			fi			
		fi
	done
	count=0
}

function findLuckiestAndUnluckiest(){
	arr="$@"
	dayIndex=1
	counter=0
	var=`echo $1| awk -F"-" '{print $2}'`
	maxFrequency=`echo $var| awk -F":" '{print $2}'`
	
	for data in ${arr[@]}
	do	
		var=`echo $data| awk -F"-" '{print $2}'`
		frequency=`echo $var| awk -F":" '{print $2}'`
		difference=$(($maxFrequency-$frequency))
		if [ $difference -lt 0 ];
		then
			maxFrequency=$frequency
			var=`echo $data| awk -F"-" '{print $1}'`
			dayIndex=`echo $var| awk -F":" '{print $2}'`
		fi
	done

	for data in ${arr[@]}
	do	
		var=`echo $data| awk -F"-" '{print $2}'`
		frequency=`echo $var| awk -F":" '{print $2}'`
		type=`echo $var| awk -F":" '{print $1}'`
		difference=$(($maxFrequency-$frequency))
		if [ $difference -eq 0 ];
		then
			if [[ $type == "wfrequency" ]];
			then
				echo "Luckiest-day-->day:$(($dayIndex+$((maxFrequency-1))))"
			else
				echo "UnLuckiest-day-->day:$(($dayIndex+$((maxFrequency-1))))"
			fi
		fi
	done
	if [[ $type == "wfrequency" ]];
	then
		echo "MostWin:$(($maxFrequency*50))"
	else
		echo "GiantLoss:$(($maxFrequency*50))"
	fi

}

while [ $dayCount -lt $totalDaysToPlay ]
do
	while [ $totalStock -lt $maxwin ] && [ $totalStock -gt $minbal ]
	do
		rno=$(($RANDOM%3))

		if [ $rno -eq 1 ];
		then
			win=$(($win+1))
			betno=$(($betno+1))
			totalStock=$(($totalStock+1))
		elif [ $rno -eq 2 ];
		then
			betno=$(($betno+1))
			loss=$(($loss+1))
			totalStock=$(($totalStock-1))
		fi
	done
	
	if [ $totalStock -eq 150 ];
	then
		echo "day:$(($dayCount+1)) --> you won $win times and loose $loss times || totalbalance = $totalStock|| result : Won"
		winCountPerDay=$(($winCountPerDay+1))
		resultOftheDay[$dayCount]="Won"
	elif [ $totalStock -eq 50 ];
	then
		echo "day:$(($dayCount+1)) --> you won $win times and loose $loss times || totalbalance = $totalStock|| result : Lost"
		lostCountPerDay=$(($lostCountPerDay+1))
		resultOftheDay[$dayCount]="Lost"
	fi
	dayCount=$(($dayCount+1))
	totalStock=100
done


echo "===================================================================================="
echo "This Month -->you won $winCountPerDay times and loose $lostCountPerDay times"
echo "------------------------------------------------------------------------------------"
calfrequency "Won"
echo ${winfrequency[@]}
calfrequency "Lost"
echo ${lostfrequency[@]}
echo "------------------------------------------------------------------------------------"

findLuckiestAndUnluckiest  ${winfrequency[@]}
findLuckiestAndUnluckiest  ${lostfrequency[@]}