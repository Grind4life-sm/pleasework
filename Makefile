USER=$(shell whoami)

##
## Configure the Hadoop classpath for the GCP dataproc enviornment
##

HADOOP_CLASSPATH=$(shell hadoop classpath)

UrlCount1.jar: UrlCount1.java
	javac -classpath $(HADOOP_CLASSPATH) -d ./ UrlCount1.java
	jar cf UrlCount1.jar UrlCount1*.class	
	-rm -f UrlCount1*.class

prepare:
	-hdfs dfs -mkdir input
	curl https://en.wikipedia.org/wiki/Apache_Hadoop > /tmp/input.txt
	hdfs dfs -put /tmp/input.txt input/file01
	curl https://en.wikipedia.org/wiki/MapReduce > /tmp/input.txt
	hdfs dfs -put /tmp/input.txt input/file02

filesystem:
	-hdfs dfs -mkdir /user
	-hdfs dfs -mkdir /user/$(USER)

run: UrlCount1.jar
	-rm -rf output
	hadoop jar UrlCount1.jar UrlCount1 input output


##
## You may need to change the path for this depending
## on your Hadoop / java setup
##
HADOOP_V=3.3.4
STREAM_JAR = /usr/lib/hadoop/hadoop-streaming-3.3.6.jar

stream:
	-rm -rf stream-output
	hadoop jar $(STREAM_JAR) \
	-mapper mapper.py \
	-reducer reducer.py \
	-file mapper.py -file reducer.py \
	-input input -output stream-output
