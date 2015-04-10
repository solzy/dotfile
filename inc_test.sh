#!/usr/bin/sh

basepath=$1
basepath2=$2
echo "args path : $1"
echo "args path: $2"
pattern="*.sql"
logdirectory="/home/zhangyun/incTest/log_`date +'%y_%m_%d_%H_%M'`"

SIMLOGS="$logdirectory/simulogs/summary.log"
INCLOGS="$logdirectory/inclogs/summary.log"


if [ ! -d "$logdirectory/simulogs" ];then
	echo "Create directory $logdirectory/simulogs"
	mkdir -p "$logdirectory/simulogs"
	touch $SIMLOGS
fi

if [ ! -d "logdirectory/inclogs" ];then
	echo "Create directory $logdirectory/inclogs"
	mkdir -p  "$logdirectory/inclogs"
	touch $INCLOGS
fi

	# incrementation simulation 
for file in `ls $basepath`
do
	if [[ ! -d "$logdirectory/simulogs/$file" && ! $file =~ .*\.sh ]];then
		mkdir -p "$logdirectory/simulogs/$file"
	fi

	if [ -d "$basepath/$file" ];then
		for innerfile in `ls $basepath/$file`
		do
			if [[ $innerfile == $pattern ]];then
				echo "Executing query : $basepath/$file/$innerfile"
				hive -f "$basepath/$file/$innerfile" >& "$logdirectory/simulogs/$file/${innerfile%.*}.log"
				echo "$file/$innerfile,Time taken:" >> $SIMLOGS
				cat "$logdirectory/simulogs/$file/${innerfile%.*}.log"| grep "^Time taken" | \
					awk -F ' ' '{printf("%f\n" ,$3)}' >> $SIMLOGS
					echo "The Log was written in $logdirectory/simulogs/$file/${innerfile%.*}.log"
			fi
		done
		echo "----------------------------------------------------------------------" >> $SIMLOGS
	fi
done

# when the second parameter is not null , to do incremental test
if [[ -n  "$basepath2" ]];then
	for file in `ls $basepath2`
	do
		#Incremental test 
		if [[ ! -d "$basepath2/$file" && $file == $pattern ]];then
			echo "Executing query : $basepath2/$file"
			hive -f "$basepath2/$file" >& "$logdirectory/inclogs/${file%.*}.log"
			echo "$file,Time taken:" >> $INCLOGS
			cat "$logdirectory/inclogs/${file%.*}.log"| grep "^Time taken" | \
				awk -F ' ' '{printf("%f\n" ,$3)}' >> $INCLOGS
			echo "The Log was written in $logdirectory/inclogs/${file%.*}.log"
		fi
	done
fi
