FROM nginx:latest
RUN apt-get -qq update 
RUN apt-get install -yqq curl