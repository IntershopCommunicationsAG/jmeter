FROM gradle:alpine AS gradle

COPY build.gradle.kts /home/gradle/project/
WORKDIR /home/gradle/project
RUN gradle copyPluginsLibExt

FROM alpine:3.16 AS nongui

ENV JMETER_VERSION 5.4.3
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN $JMETER_HOME/bin
ENV PATH="${JMETER_BIN}:$PATH" \
    TZ="Europe/Amsterdam" \
    NONGUI="TRUE"

RUN apk add --no-cache curl bash tzdata openjdk17 \
    && curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz > /tmp/jmeter.tgz \
    && tar -xvf /tmp/jmeter.tgz -C /opt \
    && rm -f /tmp/jmeter.tgz \
    && rm -f /opt/apache-jmeter-*/lib/log4j-*.* \
    && rm -f /opt/apache-jmeter-*/plugins/lib/log4j-*.* \
    && rm -f /opt/apache-jmeter-*/plugins/lib/ext/log4j-*.* \
    && apk add --no-cache nss \
    && rm -rf /var/cache/apk/*

COPY --from=gradle /home/gradle/project/build/jmeter ${JMETER_HOME}

COPY jmeter_cmd.sh /jmeter_cmd.sh

RUN curl -o ${JMETER_HOME}/plugins/lib/ext/jmeter-plugins-resultscomparator-3.1.2.jar -L https://github.com/rbourga/jmeter-plugins-2/releases/download/v3.2.1/jmeter-plugins-resultscomparator-3.1.2.jar \
    && curl -L https://jmeter-plugins.org/get/ > ${JMETER_HOME}/plugins/lib/ext/jmeter-plugins-manager.jar \
    && echo "jmeter.save.saveservice.print_field_names=true" > $JMETER_BIN/user.properties \
    && echo "server.rmi.ssl.disable=true" >> $JMETER_BIN/user.properties \
    && echo "client.rmi.localport=1099" >> $JMETER_BIN/user.properties \
    && echo "client.tries" >> $JMETER_BIN/user.properties \
    && echo "server.rmi.port=1099" >> $JMETER_BIN/user.properties \
    && echo "jmeter.laf=CrossPlatform" >> $JMETER_BIN/user.properties \
    && echo "log4j2.formatMsgNoLookups=true" >> $JMETER_BIN/system.properties \
    && chmod a+x /jmeter_cmd.sh

EXPOSE 1099

VOLUME ["/tests", "/testlogs", "/testdata"]

WORKDIR /tests

CMD [ "/jmeter_cmd.sh" ]

FROM nongui AS gui

ENV DISPLAY=":99" \
    RESOLUTION="1366x768x24" \
    PASS="root" \
    NONGUI="FALSE"

RUN apk add --no-cache xfce4-terminal xvfb x11vnc xfce4 xrdp openssl icu-data-full \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
    && x11vnc -storepasswd ${PASS} /etc/x11vnc.pass \
    && echo "[Globals]" > /etc/xrdp/xrdp.ini \
    && echo "bitmap_cache=true" >> /etc/xrdp/xrdp.ini \
    && echo "bitmap_compression=true" >> /etc/xrdp/xrdp.ini \
    && echo "autorun=jmeter" >> /etc/xrdp/xrdp.ini \
    && echo "port=3389" >> /etc/xrdp/xrdp.ini \
    && echo "[jmeter]" >> /etc/xrdp/xrdp.ini \
    && echo "name=jmeter" >> /etc/xrdp/xrdp.ini \
    && echo "lib=libvnc.so" >> /etc/xrdp/xrdp.ini \
    && echo "ip=localhost" >> /etc/xrdp/xrdp.ini \
    && echo "port=5900" >> /etc/xrdp/xrdp.ini \
    && echo "username=root" >> /etc/xrdp/xrdp.ini \
    && echo "password=${PASS}" >> /etc/xrdp/xrdp.ini

EXPOSE 5900
EXPOSE 3389

WORKDIR /tests

CMD ["bash", "-c", "rm -f /tmp/.X99-lock && rm -f /var/run/xrdp.pid\
    && nohup bash -c \"/usr/bin/Xvfb :99 -screen 0 ${RESOLUTION} -ac +extension GLX +render -noreset && export DISPLAY=99 > /dev/null 2>&1 &\"\
    && nohup bash -c \"startxfce4 > /dev/null 2>&1 &\"\
    && nohup bash -c \"x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :99 -forever -bg -nopw -rfbport 5900 -rfbauth /etc/x11vnc.pass > /dev/null 2>&1\"\
    && nohup bash -c \"xrdp > /dev/null 2>&1\"\
    && nohup bash -c \"/jmeter_cmd.sh > /dev/null 2>&1 &\"\
    && tail -f /dev/null"]
