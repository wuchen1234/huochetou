FROM debian:latest

# 更新包列表并安装 openssh-server 和 OpenJDK 11
RUN apt-get update && \
    apt-get install -y openssh-server openjdk-11-jdk && \
    apt-get clean

# 创建 SSH 所需目录
RUN mkdir /var/run/sshd

# 修改 SSH 配置，允许 root 通过密码登录
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 设置 root 密码（此处密码为 "uncleluo"，请根据需要修改）
RUN echo "root:uncleluo" | chpasswd

# 可选：设置 JAVA_HOME 环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# 暴露 SSH 默认端口 22
EXPOSE 22

# 启动 SSH 服务
CMD ["/usr/sbin/sshd", "-D"]

