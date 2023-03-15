ARG NODEJS_VERSION
FROM node:${NODEJS_VERSION}-alpine as base
LABEL maintainer Naba Das <hello@get-deck.com>

WORKDIR /src
RUN apk add nano bash tar openjdk11 unzip libstdc++ curl

EXPOSE 3000
RUN npm i -g ionic cordova @ionic/cli
RUN ionic --no-interactive config set -g daemon.updates false

# Install Android SDK tools
# ENV ANDROID_HOME /opt/android-sdk-linux
# ENV SDK_TOOLS_VERSION 25.2.5
# ENV API_LEVELS android-23
# ENV BUILD_TOOLS_VERSIONS build-tools-25.0.2,build-tools-23.0.1
# ENV ANDROID_EXTRAS extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository
# ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
# RUN mkdir -p /opt/android-sdk-linux && cd /opt \
#     && wget -q http://dl.google.com/android/repository/tools_r${SDK_TOOLS_VERSION}-linux.zip -O android-sdk-tools.zip \
#     && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
#     && rm -f android-sdk-tools.zip \
#     && echo y | android update sdk --no-ui -a --filter \
#        tools,platform-tools,${ANDROID_EXTRAS},${API_LEVELS},${BUILD_TOOLS_VERSIONS} --no-https
ARG ANDROID_SDK_VERSION="3859397"
ARG ANDROID_HOME="/opt/android-sdk"
ARG ANDROID_BUILD_TOOLS_VERSION="26.0.2"
ENV ANDROID_HOME "${ANDROID_HOME}"
RUN curl -fSLk https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip -o sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    && unzip sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    && mkdir /opt/android-sdk \
    && mv tools /opt/android-sdk \
    && (while sleep 3; do echo "y"; done) | $ANDROID_HOME/tools/bin/sdkmanager --licenses \
    && $ANDROID_HOME/tools/bin/sdkmanager "platform-tools" \
    && $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"

# COPY distribution/ /distribution/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
CMD ["ionic"]
# CMD [ "node" ]
