## Dockerfile for building a docker pop2imap image

# I use the following command to build the image:
#
#  docker build -t stuckj/pop2imap .
#
# where this Dockerfile is in the current directory
#
# NOTE [JPS]: This is adapted from the imapsync Dockerfile referenced from
# the imapsync dockerhub image here: https://hub.docker.com/r/gilleslamiral/imapsync/

FROM debian:stretch

LABEL maintainer "pop2imap author: gilles@lamiral.info, Dockerfile (only) author: stuckj@gmail.com"

COPY Dockerfile /

RUN apt-get update \
  && apt-get install -y \
  libmail-pop3client-perl \
  libmail-imapclient-perl \
  libemail-simple-perl \
  libdate-manip-perl \
  procps \
  wget \
  make \
  cpanminus \
  && rm -rf /var/lib/apt/lists/*

RUN wget -N http://www.linux-france.org/prj/pop2imap/pop2imap \
  && cp pop2imap /usr/bin/pop2imap \
  && chmod +x /usr/bin/pop2imap

USER nobody

ENV HOME /var/tmp/

CMD ["/usr/bin/pop2imap"]

#
# End of pop2imap Dockerfile
