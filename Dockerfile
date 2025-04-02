FROM debian:latest

# 更新包列表并安装 openssh-server 和 openjdk-17-jdk
RUN apt-get update && \
    apt-get install -y openssh-server openjdk-17-jdk && \
    apt-get clean

# 创建 SSH 所需目录，并修改 SSH 配置允许 root 密码登录
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "root:uncleluo" | chpasswd

# 设置 JAVA_HOME 环境变量，并添加到 PATH 中
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# 暴露 SSH 默认端口 22
EXPOSE 22

# 启动 SSH 服务
CMD ["/usr/sbin/sshd", "-D"]

