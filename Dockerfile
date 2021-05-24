FROM amazonlinux:2

RUN yum -y update --skip-broken \
    && yum -y upgrade \
    && yum install -y shadow-utils unzip tar xz gzip gcc openssl-devel bzip2-devel libffi-devel make wget

RUN wget https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tgz \
    && tar xvf Python-3.9.5.tgz \
    && cd Python-3.9*/ \
    && ./configure --enable-optimizations \
    && make altinstall

CMD ["python3.9"]
