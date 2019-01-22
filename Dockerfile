# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM ubuntu:16.04

RUN echo 'mysql-server mysql-server/root_password password root' | debconf-set-selections \
    && echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections

RUN apt-get -qq update && apt-get install -qq \
    genisoimage \
    libffi-dev \
    libssl-dev \
    sudo \
    ipmitool \
    maven \
    netcat \
    openjdk-8-jdk \
    python-dev \
    python-setuptools \
    python-pip \
    python-mysql.connector \
    supervisor \
    wget \
    nginx \
    jq \
    mysql-server \
    openssh-client \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/* \
    && dpkg -l | tee /installed.log

RUN mkdir -p /var/run/mysqld \
    && chown mysql /var/run/mysqld \
    && echo '''sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"''' >> /etc/mysql/mysql.conf.d/mysqld.cnf

RUN find /var/lib/mysql -type f -exec touch {} \; && (/usr/bin/mysqld_safe &) && sleep 30 && mysqladmin -u root -proot password ''

RUN wget https://github.com/apache/cloudstack/archive/4.11.2.0.tar.gz -O /opt/cloudstack.tar.gz \
    && mkdir -p /opt/cloudstack \
    && tar xvzf /opt/cloudstack.tar.gz -C /opt/cloudstack --strip-components=1

WORKDIR /opt/cloudstack

CMD ["cat", "/installed.log"]
