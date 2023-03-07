ARG NODEJS_VERSION
FROM node:${NODEJS_VERSION}-alpine as base

WORKDIR /src
RUN apk add nano bash tar
EXPOSE 3000
RUN npm i -g ionic cordova @ionic/cli
RUN ionic --no-interactive config set -g daemon.updates false

# COPY distribution/ /distribution/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
CMD ["ionic"]
# CMD [ "node" ]
