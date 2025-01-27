FROM ubuntu:24.04

RUN apt-get update && apt-get install -y openjdk-17-jdk wget ssh iputils-ping telnet net-tools && \
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
    tar -xzf hadoop-3.3.6.tar.gz -C /usr/local && \
    mv /usr/local/hadoop-3.3.6 /usr/local/hadoop && \
    rm hadoop-3.3.6.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
ENV PATH=$PATH=$JAVA_HOME/bin:$PATH
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

COPY core-site.xml hdfs-site.xml /usr/local/hadoop/etc/hadoop/
COPY bootstrap.sh /bootstrap.sh

RUN chmod +x /bootstrap.sh

CMD ["/bootstrap.sh"]
