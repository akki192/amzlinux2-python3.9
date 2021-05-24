FROM amazonlinux:2

RUN yum -y update --skip-broken \
    && yum -y upgrade \
    && yum install -y shadow-utils unzip tar xz gzip gcc openssl-devel bzip2-devel libffi-devel make \
    && mkdir -p /apps/python

WORKDIR /apps/python
ADD https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tgz /apps/python
RUN tar xzf Python-3.9.5.tgz \
    && cd Python-3.9.5 \
    && ./configure --enable-optimizations \
    && make altinstall \
    && python3.9 -V
RUN cd /usr/local/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config

ENV PYTHON_PIP_VERSION 21.1.1
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/1954f15b3f102ace496a34a013ea76b061535bd2/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256 f499d76e0149a673fb8246d88e116db589afbd291739bd84f2cd9a7bca7b6993

RUN set -ex; \
	\
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum --check --strict -; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==$PYTHON_PIP_VERSION" \
	; \
	pip --version; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' +; \
	rm -f get-pip.py

CMD ["amzlinux2-python3.9"]
