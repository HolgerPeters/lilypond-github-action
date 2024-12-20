FROM debian:latest
# Note: GitHub Actions must be run by the default Docker user (root). Ensure your Dockerfile does not set the USER instruction, otherwise you will not be able to access GITHUB_WORKSPACE.

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -p /usr/share/man/man1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qy update && \
    apt-get -yq install lilypond git make texlive-base m4 && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENV HOME_DIR /app

WORKDIR $HOME_DIR

ENTRYPOINT ["/entrypoint.sh"]
