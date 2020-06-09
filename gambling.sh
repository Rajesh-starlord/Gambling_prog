#! /bin/bash 
#gambling


TOTAL_STACK=100
MAX_STACK=150
MIN_STACK=50
TOTAL_DAYS_TO_PLAY=30

winCount=0
betno=0
lossCount=0
minbal=$(($TOTAL_STACK-$MIN_STACK))
dayCount=0
totalwinCountCountOfDay=0
totalLostCountOfDay=0
declare -a resultOftheDay
declare -a winCountfrequency
declare -a lostfrequency

count=0
frequency=0
function calfrequency(){
	for (( i=count;i<30;i++ ))
	do	
		if [[ ${resultOftheDay[i]} == $1 ]] && [ $i -ne 29 ];
		then
			frequency=$(($frequency+1))
		elif [[ ${resultOftheDay[i]} != $1 ]];
		then
			if [ $frequency -ne 0 ];
			then
				if [[ $1 == "Won" ]];
				then
					winCountfrequency[$i]="startDay:$(($count+1))-wfrequency:$frequency"
				elif [[ $1 == "Lost" ]];
				then
					lostfrequency[$i]="startDay:$(($count+1))-lfrequency:$frequency"
				fi
			fi
			count=$(($i+1))
			frequency=0

		elif  [ $i -eq 29 ];
		then
			if [[ $1 == "Won" ]];
			then
				winCountfrequency[$i]="startDay:$(($count+1))-wfrequency:$(($frequency+1))"
			elif [[ $1 == "Lost" ]];
			then
				lostfrequency[$i]="startDay:$(($count+1))-lfrequency:$(($frequency+1))"
			fi			
		fi
	done
	count=0
	frequency=0
}

function findLuckiestAndUnluckiest(){
	arr="$@"
	counter=0
	var=`echo $1| awk -F"-" '{print $2}'`
	maxFrequency=`echo $var| awk -F":" '{print $2}'`
	type=`echo $var| awk -F":" '{print $1}'`
	day=`echo $1| awk -F"-" '{print $2}'`
	dayIndex=`echo $day| awk -F":" '{print $2}'`
	
	if [[ $type == "wfrequency" ]];
	then
		typeOfDay="Lukiest-Day"
	else
		typeOfDay="UnLukiest-Day"
	fi
		
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
	
	echo "$typeOfDay --> day:$(($dayIndex+$((maxFrequency-1))))"
	
	for data in ${arr[@]}
	do	
		var=`echo $data| awk -F"-" '{print $2}'`
		frequency=`echo $var| awk -F":" '{print $2}'`
		difference=$(($maxFrequency-$frequency))
		if [[ $difference == 0 ]];
		then
			var1=`echo $data| awk -F"-" '{print $1}'`
			dayIndex1=`echo $var1| awk -F":" '{print $2}'`
			if [[ $dayIndex1 -ne $dayIndex ]];
			then
				echo "$typeOfDay -->day:$(($dayIndex1+$((maxFrequency-1))))"
			fi
		fi
	done
	if [[ $type == "wfrequency" ]];
	then
		echo "MostwinCount:$(($maxFrequency*50))"
	else
		echo "GiantlossCount:$(($maxFrequency*50))"
	fi

}

while [ $dayCount -lt $TOTAL_DAYS_TO_PLAY ]
do
	while [ $TOTAL_STACK -lt $MAX_STACK ] && [ $TOTAL_STACK -gt $minbal ]
	do
		rno=$(($RANDOM%3))

		if [ $rno -eq 1 ];
		then
			winCount=$(($winCount+1))
			betno=$(($betno+1))
			TOTAL_STACK=$(($TOTAL_STACK+1))
		elif [ $rno -eq 2 ];
		then
			betno=$(($betno+1))
			lossCount=$(($lossCount+1))
			TOTAL_STACK=$(($TOTAL_STACK-1))
		fi
	done
	
	if [ $TOTAL_STACK -eq 150 ];
	then
		echo "day:$(($dayCount+1)) --> you won $winCount times and loose $lossCount times || totalbalance = $TOTAL_STACK|| resultOfToDay : Won"
		totalwinCountCountOfDay=$(($totalwinCountCountOfDay+1))
		resultOftheDay[$dayCount]="Won"
	elif [ $TOTAL_STACK -eq 50 ];
	then
		echo "day:$(($dayCount+1)) --> you won $winCount times and loose $lossCount times || totalbalance = $TOTAL_STACK|| totalDaysToPlay : Lost"
		totalLostCountOfDay=$(($totalLostCountOfDay+1))
		resultOftheDay[$dayCount]="Lost"
	fi
	dayCount=$(($dayCount+1))
	TOTAL_STACK=100
done


echo "===================================================================================="
echo "This Month -->you won $totalwinCountCountOfDay times and loose $totalLostCountOfDay times"
echo "------------------------------------------------------------------------------------"
calfrequency "Won"
echo ${winCountfrequency[@]}
calfrequency "Lost"
echo ${lostfrequency[@]}
echo "------------------------------------------------------------------------------------"

findLuckiestAndUnluckiest  ${winCountfrequency[@]}
findLuckiestAndUnluckiest  ${lostfrequency[@]}

echo "======================================================================================"

if [ $totalwinCountCountOfDay -gt $totalLostCountOfDay ];
then	
	echo "you won $ $(((($totalwinCountCountOfDay-$totalLostCountOfDay))*50)) This month"
	echo "You can continue Gambling..."
elif [ $totalwinCountCountOfDay -lt $totalLostCountOfDay ];
then
	echo "you lost $ $(((($totalLostCountOfDay-$totalwinCountCountOfDay))*50)) This month"
	echo "You Should stop Gambling..."
else
	echo "equal winCount and lossCount value"
	echo "Your Wish...."
fi
