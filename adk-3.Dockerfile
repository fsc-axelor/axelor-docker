FROM openjdk:7 AS webapp

ENV ADK_VERSION 3.3.4

WORKDIR /adk
ADD https://github.com/axelor/axelor-open-platform/archive/refs/tags/v$ADK_VERSION.tar.gz ./
RUN tar xf v$ADK_VERSION.tar.gz

WORKDIR /adk/axelor-open-platform-$ADK_VERSION
RUN ./gradlew installApp

ENV AXELOR_HOME /adk/axelor-open-platform-$ADK_VERSION/build/install/axelor-development-kit

WORKDIR /webapp
COPY . .
RUN ./gradlew clean build -xtest

FROM tomcat:7

ENV WEBAPP_VERSION 1.0.6

COPY --from=webapp /webapp/build/libs/webapp-$WEBAPP_VERSION.war /usr/local/tomcat/webapps/ROOT.war
