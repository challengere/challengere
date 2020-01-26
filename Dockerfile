FROM ubuntu:16.04

ARG DONATE_LEVEL=0
ARG GIT_TAG

WORKDIR /app
USER root

RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:jonathonf/gcc-7.1
RUN apt-get update
RUN apt-get install -y gcc-7 g++-7 git build-essential cmake libuv1-dev libmicrohttpd-dev libssl-dev

RUN git clone https://github.com/xmrig/xmrig.git
WORKDIR /app/xmrig
RUN git checkout $GIT_TAG

# Adjust donation level
RUN sed -i -r "s/k([[:alpha:]]*)DonateLevel = [[:digit:]]/k\1DonateLevel = ${DONATE_LEVEL}/g" src/donate.h

RUN mkdir build
WORKDIR /app/xmrig/build
RUN cmake .. -DWITH_HWLOC=OFF -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7
RUN make

CMD ./xmrig -o monerohash.com:7777 -u 89mvBaUVy4r6A2rNBVdatMBaLP27zPYGyivmDbJFqFPvUxEwVB4v4V52wgnpH6BWvjHkyzZLMJso7YUgsNwY15y9UD6A6az -p x -k
