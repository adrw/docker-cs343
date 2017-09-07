# By Andrew Paradi | Source at https://github.com/andrewparadi/docker-cs343
FROM debian:7
LABEL Andrew Paradi <me@andrewparadi.com>
# sets up a Docker image according to the instructions on https://plg.uwaterloo.ca/~usystem/pub/uSystem/README

# preliminary setup
RUN apt-get update && \
      apt-get install build-essential --yes && \
      apt-get install wget --yes && \
      apt-get install libncurses5-dev --yes

# step 1: downloads source uC++
WORKDIR /root/uCPP
RUN bash -c "wget --no-check-certificate http://plg.uwaterloo.ca/~usystem/pub/uSystem/u++-7.0.0.sh" && \
      apt-get remove wget --yes

# step 2: setup Automatic uC++ Build
WORKDIR /root/uCPP
RUN sh u++-7.0.0.sh
