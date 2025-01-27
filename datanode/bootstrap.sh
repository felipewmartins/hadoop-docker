#!/bin/bash

service ssh start

$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode

tail -f /dev/null
