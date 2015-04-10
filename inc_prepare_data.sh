#!/bin/sh

usage(){ echo "Usage: ./inc_prepare_data.sh -t inctimes -p datapath 
		 	  Example: incTest/inc_prepare_data.sh  -t 2 -p main/zhangyun/testQL/TPC-H-Hive/dbgen/lineitem.tbl"; }
#get arguments
while getopts ":t:p:" args
do
	case "$args" in
		t)
			inctimes=${OPTARG}
			;;
		p)
			datapath=${OPTARG}
			;;
		*)
			usage
			;;
		esac
done

shift $((OPTIND-1))
if [ -z "${inctimes}" ] || [ -z "${datapath}" ];then
	usage
fi

sql=""

#Creating directory 
for((i=4;i<=$inctimes;i++)){
	$HADOOP_HOME/bin/hadoop fs -mkdir "/tpch/lineitem$i"
	echo "mkdir lineitem$i in HDFS"
	sql=${sql}"Create external table lineitem$i (L_ORDERKEY INT, L_PARTKEY INT, L_SUPPKEY INT, L_LINENUMBER INT, L_QUANTITY DOUBLE, L_EXTENDEDPRICE DOUBLE, L_DISCOUNT DOUBLE, L_TAX DOUBLE, L_RETURNFLAG STRING, L_LINESTATUS STRING, L_SHIPDATE STRING, L_COMMITDATE STRING, L_RECEIPTDATE STRING, L_SHIPINSTRUCT STRING, L_SHIPMODE STRING, L_COMMENT STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE LOCATION '/tpch/lineitem$i';"
}

#Uploading data file 
for((d=4;d<=inctimes;d++)){
	for((n=0;n<$d;n++)){
		$HADOOP_HOME/bin/hadoop fs -copyFromLocal $datapath "/tpch/lineitem$d/data$n.tbl"
		echo "From $datapath copying to  /tpch/lineitem$d/data$n.tbl"
	}
}

#creating test tables(simulation of incremental table)
hive -e  "\"$sql\"" 

