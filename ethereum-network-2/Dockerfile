FROM ubuntu:18.04
RUN apt-get update && apt-get install -y software-properties-common net-tools
RUN add-apt-repository -y ppa:ethereum/ethereum && apt-get update
RUN apt-get -y install ethereum
ADD ./gen2.json /root/mygenesis.json
EXPOSE 8545 8546 8547 30303 30303/udp
RUN mkdir -p /root/datadir
ENTRYPOINT "bash"
