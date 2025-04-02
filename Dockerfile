FROM centos:centos6
MAINTAINER Fanbin Kong "kongxx@hotmail.com"

# 备份并替换 CentOS-Base.repo
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
RUN yum clean all
RUN yum makecache

# 安装openssh-server和sudo软件包，并且将sshd的UsePAM参数设置成no
RUN yum install -y openssh-server sudo
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config 

# 添加测试用户admin，密码admin，并且将此用户添加到sudoers里
RUN useradd -p $(openssl passwd -1 admin) admin
RUN echo "admin  ALL=(ALL)    ALL" >> /etc/sudoers

# 下面这两句比较特殊，在centos6上必须要有，否则创建出来的容器sshd不能登录
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key

# 启动sshd服务并且暴露22端口
RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]    



