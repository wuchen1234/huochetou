FROM debian:buster

# 更新软件包列表并升级系统
RUN apt update && apt upgrade -y



# 安装 wget 和其他必要的依赖包
RUN apt install -y wget gnupg2 ca-certificates lsb-release

# 安装 Java 11
RUN apt install -y openjdk-11-jdk git

# 安装其他必要的软件包
RUN apt install -y ssh npm nginx

# 全局安装 wstunnel
RUN npm install -g wstunnel

# 下载 frps 一键安装脚本
RUN wget https://raw.githubusercontent.com/MvsCode/frps-onekey/master/install-frps.sh -O ./install-frps.sh

# 赋予脚本执行权限
RUN chmod 700 ./install-frps.sh

# 执行 frps 安装脚本
RUN sh -c '/bin/echo -e "2\n5130\n5131\n5132\n5133\nadmin\nadmin\n\n\n\n\n\n\n\n\n\n" | ./install-frps.sh install'

# 创建 sshd 运行目录
RUN mkdir /run/sshd

# 编写启动脚本
RUN echo '/usr/sbin/sshd -D &' >>/1.sh
RUN echo '/etc/init.d/frps restart' >>/1.sh
# 启动 Nginx 服务
RUN echo '/usr/sbin/nginx -g "daemon off;"' >>/1.sh

# 修改 SSH 配置，允许 root 用户登录
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 设置 root 用户密码
RUN echo root:uncleluo|chpasswd

# 赋予启动脚本执行权限
RUN chmod 755 /1.sh

# 暴露端口，添加 Nginx 常用端口
EXPOSE 22 80 8080 8888 443 5130 5131 5132 5133 5134 5135 3306

# 容器启动时执行启动脚本
CMD  /1.sh       
