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

COPY --chown=root:root ./configs /configs

RUN chmod 700 -R /scripts /configs && chmod +x -R /scripts