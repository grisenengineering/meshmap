FROM alpine

RUN apk update
RUN apk add bash
RUN apk add iperf
RUN apk add fping
RUN apk add zabbix-agent


RUN mkdir /usr/share/meshmap
RUN mkdir /usr/sbin/meshmap
RUN mkdir /etc/meshmap

COPY container.sh /usr/sbin/meshmap/container.sh
COPY discover_nodes.sh /usr/sbin/meshmap/discover_nodes.sh
COPY get_icmp.sh /usr/sbin/meshmap/get_icmp.sh
COPY test_icmp.sh /usr/sbin/meshmap/test_icmp.sh
COPY system_status.sh /usr/sbin/meshmap/system_status.sh

COPY nodelist.conf /etc/meshmap/nodelist.conf

COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

EXPOSE 10050:10050

RUN echo '*/5  *  *  *  *    /usr/sbin/test_icmp.sh' >> /etc/crontabs/root

CMD ["/usr/sbin/meshmap/container.sh"]
