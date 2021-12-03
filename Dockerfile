FROM docker:20.10.11-git

RUN apk update 

RUN apk add bash &&\
    apk add ncurses

RUN addgroup docker -g 998 

COPY --chown=root:root ./installer /installer

RUN chmod 700 -R /installer