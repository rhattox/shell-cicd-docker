FROM alpine:3.15
RUN apk update && \
    apk add openrc && \
    apk add docker && \
    apk add bash
RUN rc-update add docker boot

COPY --chown=root:root ./installer /installer

COPY --chown=root:root ./scripts /scripts

RUN chmod 700 -R /scripts

ENTRYPOINT [ "/scripts/cicd_docker.sh" ]