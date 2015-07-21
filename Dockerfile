FROM ubuntu:14.04
MAINTAINER Per-Gustaf Stenberg

RUN apt-get update && apt-get -y install software-properties-common \
&& add-apt-repository ppa:webupd8team/java && apt-get update \
&& echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections \
&& echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections \
&& apt-get -y install oracle-java8-installer

RUN wget -qO- https://get.docker.com/ | sh

RUN apt-get update && apt-get install -y openssh-server \
&& mkdir /var/run/sshd \
&& echo 'root:jenkins' | chpasswd \
&& sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


