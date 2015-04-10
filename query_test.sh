#!/bin/sh
usage(){ echo "Usage: ./query_test.sh -t inctimes -qp querypath -rp resultdirectoy
		example: ./query_test.sh  -t 3 -q incTestCase/q1.sql  -r test/ "; }
#get arguments

if [ $# -le 4 ];then
	usage
	exit 1
fi

while getopts ":t:q:r:" args
do
	case "$args" in
		t)
			inctimes=${OPTARG}
			;;
		q)
			querypath=${OPTARG}
			;;
		r)
			resultdirectoy=${OPTARG}
			;;
		*)
			usage
			;;
		esac
done

#echo $inctimes
#echo $querypath
#echo $resultdirectoy
#trim "/" at the end of line
if [ `echo $resultdirectoy | sed -n '/.*\/$/p'` ];then
	resultdirectoy=${resultdirectoy%?}
fi

config="set hive.inctimes=$inctimes;"

content=${config}`cat $querypath`

echo 
#Executing incremental query
echo "Executing incremental query : $content"
hive -e "$content" >& $resultdirectoy/inc.logs

#Delete parameters of increment
#content=`cat $querypath | sed  "s/\/\*.*\*\///g" `

#Create directory of collecting logs of simulation test
if [ ! -d "$resultdirectoy/simlogs" ];then
	mkdir "$resultdirectoy/simlogs"
fi

for((i=1;i<=$inctimes;i++)){
	sql=`cat $querypath | sed  "s/\/\*.*\*\///g" | sed "s/lineitem/lineitem${i} /"`
	echo "Executing incremental query of simulation : $sql"
	hive -e "$sql" >& $resultdirectoy/simlogs/$i.log
}
