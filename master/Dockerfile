FROM ubuntu:24.04

# Instala pacotes necessários, incluindo o SSH
RUN apt-get update && apt-get install -y openjdk-17-jdk wget ssh iputils-ping telnet net-tools vim openssh-server && \
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
    tar -xzf hadoop-3.3.6.tar.gz -C /usr/local && \
    mv /usr/local/hadoop-3.3.6 /usr/local/hadoop && \
    rm hadoop-3.3.6.tar.gz

RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config

# Cria o usuário não root para o Hadoop
RUN useradd -m -s /bin/bash hadoop

# Cria o diretório SSH e configura permissões
RUN mkdir -p /home/hadoop/.ssh && \
    echo "hadoop:hadoop" | chpasswd && \
    ssh-keygen -t rsa -P '' -f /home/hadoop/.ssh/id_rsa && \
    cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys && \
    chmod 600 /home/hadoop/.ssh/authorized_keys && \
    chmod 700 /home/hadoop/.ssh

# Cria e configura o diretório necessário para o SSH
RUN mkdir -p /run/sshd && chmod 755 /run/sshd

# Define permissões para os diretórios do Hadoop
RUN mkdir -p /hadoop_data && \
    chown -R hadoop:hadoop /hadoop_data && \
    chown -R hadoop:hadoop /usr/local/hadoop && \
    chown -R hadoop:hadoop /home/hadoop/.ssh

# Configura variáveis de ambiente
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# Configurar variáveis de ambiente para o usuário hadoop
RUN echo "export JAVA_HOME=$JAVA_HOME" >> /home/hadoop/.bashrc && \
    echo "export HADOOP_HOME=$HADOOP_HOME" >> /home/hadoop/.bashrc && \
    echo "export PATH=$PATH" >> /home/hadoop/.bashrc

RUN sed -i "/export JAVA_HOME/c\export JAVA_HOME=$JAVA_HOME" $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# Copia arquivos de configuração
COPY core-site.xml hdfs-site.xml /usr/local/hadoop/etc/hadoop/
COPY bootstrap.sh /bootstrap.sh

# Define permissões e mantém o usuário root inicialmente
RUN chmod +x /bootstrap.sh
USER root

# Comando inicial para o container
CMD ["/bootstrap.sh"]
