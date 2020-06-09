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
balance=0
declare -a resultOftheDay
declare -a winCountfrequency
declare -a lostfrequency
declare -a balanceOfaDay

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
	maxBalance=`echo $1| awk -F"=" '{print $2}'`
	minBalance=`echo $1| awk -F"=" '{print $2}'`
	var=`echo $1| awk -F"=" '{print $1}'`
	LuckiestDay=`echo $var| awk -F":" '{print $2}'`
	UnLuckiestDay=`echo $var| awk -F":" '{print $2}'`
	
	for data in ${arr[@]}
	do	
		Balance=`echo $data| awk -F"=" '{print $2}'`
		if [[ $Balance -gt $maxBalance ]];
		then
			maxBalance=$Balance
			var=`echo $data| awk -F"=" '{print $1}'`
			LuckiestDay=`echo $var| awk -F":" '{print $2}'`
		fi
		if [[ $Balance -lt $minBalance ]];
		then
			minBalance=$Balance
			var=`echo $data| awk -F"=" '{print $1}'`
			UnLuckiestDay=`echo $var| awk -F":" '{print $2}'`
		fi
	done
	
	echo "LuckiestDay=Day-$LuckiestDay"
	echo "UnLuckiestDay=Day-$UnLuckiestDay"
	
	for data in ${arr[@]}
	do	
		Balance=`echo $data| awk -F"=" '{print $2}'`
		if [[ $Balance -eq $maxBalance ]];
		then
			var=`echo $data| awk -F"=" '{print $1}'`
			Day=`echo $var| awk -F":" '{print $2}'`
			if [[ $Day -ne $LuckiestDay ]];
			then
				echo "LuckiestDay=Day-$Day"
			fi
		fi
		if [[ $Balance -eq $minBalance ]];
		then
			var=`echo $data| awk -F"=" '{print $1}'`
			Day=`echo $var| awk -F":" '{print $2}'`
			if [[ $Day -ne $UnLuckiestDay ]];
			then
				echo "UnLuckiestDay=Day-$Day"
			fi
		fi
	done
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
		balance=$(($balance+50))
		balanceOfaDay[$dayCount]="Day:$dayCount=$balance"
		resultOftheDay[$dayCount]="Lost"
		echo "day:$(($dayCount+1)) --> you won $winCount times and lost $lossCount times || totalbalance = $TOTAL_STACK|| result : Won ||balanceOfaDay : $balance"
		totalwinCountCountOfDay=$(($totalwinCountCountOfDay+1))
	elif [ $TOTAL_STACK -eq 50 ];
	then
		balance=$(($balance-50))
		balanceOfaDay[$dayCount]="Day:$(($dayCount+1))=$balance"
		resultOftheDay[$dayCount]="Lost"
		echo "day:$(($dayCount+1)) --> you won $winCount times and lost $lossCount times || totalbalance = $TOTAL_STACK|| result : Lost||balanceOfaDay : $balance"
		totalLostCountOfDay=$(($totalLostCountOfDay+1))
	fi
	dayCount=$(($dayCount+1))
	TOTAL_STACK=100
done


echo "===================================================================================="
echo "This Month -->you won $totalwinCountCountOfDay times and loose $totalLostCountOfDay times"
echo "------------------------------------------------------------------------------------"

findLuckiestAndUnluckiest ${balanceOfaDay[@]}

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
