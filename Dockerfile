FROM centos:centos7

# change these to match your pool
#

ENV GID 500
ENV UID 501

RUN groupadd -g $GID condor \
    && useradd --uid $UID --gid $GID -N -c 'condor user' condor

RUN yum -y install openssh-clients wget curl sudo which docker singularity \
    && rpm --import https://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor \
    && cd /etc/yum.repos.d && wget https://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo \
    && yum -y install condor \
    && yum clean all \
    && rm -f RPM-GPG-KEY-HTCondor \
    && sed -i 's/\(^Defaults.*requiretty.*\)/#\1/' /etc/sudoers \
    && rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && rm -rf /etc/condor \
    && rm -rf /var/lib/condor

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
