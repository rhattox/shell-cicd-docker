FROM docker:20.10.11-git

RUN apk update 

RUN apk add bash &&\
    apk add ncurses &&\
    apk add curl &&\
    apk add python3 &&\
    apk add --update py-pip &&\
    pip install python-dotenv 

RUN addgroup docker -g 998 

COPY --chown=root:root ./scripts /scripts

COPY --chown=root:root ./packages/confd-0.16.0-linux-amd64 /opt/confd/bin/confd

COPY --chown=root:root ./configs /configs

RUN chmod +x /opt/confd/bin/confd 

RUN export PATH="$PATH:/opt/confd/bin"

RUN mkdir /tmp/confd

RUN chmod 700 -R /scripts /configs && chmod +x -R /scripts