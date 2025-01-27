#!/bin/bash

# Inicia o serviço SSH como root
service ssh start

# Configura o JAVA_HOME e o PATH para o ambiente Hadoop
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
export PATH=$JAVA_HOME/bin:$PATH
export HADOOP_HOME=/usr/local/hadoop
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# Verifica se o diretório /run/sshd existe e cria se necessário
if [ ! -d /run/sshd ]; then
    mkdir -p /run/sshd
    chmod 755 /run/sshd
fi

# Troca para o usuário 'hadoop' para executar os comandos Hadoop
su - hadoop -c "
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
    export PATH=$JAVA_HOME/bin:$PATH
    export HADOOP_HOME=/usr/local/hadoop
    export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

    # Gera as chaves SSH, se necessário
    if [ ! -f /home/hadoop/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -P '' -f /home/hadoop/.ssh/id_rsa
    fi

    # Autoriza a chave para login sem senha
    cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
    chmod 600 /home/hadoop/.ssh/authorized_keys

    # Formata o NameNode, se necessário
    # $HADOOP_HOME/bin/hdfs namenode -format -force

    # Inicia os serviços do Hadoop
    $HADOOP_HOME/sbin/start-dfs.sh
"

# Mantém o container ativo
tail -f /dev/null
