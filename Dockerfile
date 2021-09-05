FROM debian
RUN apt update
RUN apt install ssh wget npm -y
RUN  npm install -g wstunnel
RUN mkdir /run/sshd 
RUN echo 'wstunnel -s 0.0.0.0:80 &' >>/1.sh
RUN echo '/usr/sbin/sshd -D' >>/1.sh
RUN echo 'wget https://raw.githubusercontent.com/MvsCode/frps-onekey/master/install-frps.sh -O ./install-frps.sh' >>/1.sh
RUN echo 'chmod 700 ./install-frps.sh' >>/1.sh
RUN echo './install-frps.sh install' >>/1.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo root:uncleluo|chpasswd
RUN chmod 755 /1.sh
EXPOSE 80 8888 443 5130 5131 5132 5133 5134 5135 3306
CMD  /1.sh
