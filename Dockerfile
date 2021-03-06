FROM ubuntu:bionic
MAINTAINER Dom De Re <domdere@irreverentpixelfeats.com>

ENV LC_ALL=en_US.utf8
ENV TERM=xterm-256color

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Australia

## deps
RUN apt-get update -y \
  && apt-get upgrade -y \
  && apt-get dist-upgrade -y \
  && apt-get install -y curl wget gnupg language-pack-en dos2unix software-properties-common apt-transport-https autoconf automake build-essential libtool make gcc g++ libgmp-dev ncurses-dev libtinfo-dev python3 xz-utils dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev \
  && curl -o /tmp/ipf-public-key.asc "https://bintray.com/user/downloadSubjectPublicKey?username=irreverent-pixel-feats" \
  && dos2unix /tmp/ipf-public-key.asc \
  && apt-key add /tmp/ipf-public-key.asc \
  && add-apt-repository -y "https://dl.bintray.com/irreverent-pixel-feats/ipf bionic main" \
  && apt-add-repository -y "ppa:kelleyk/emacs" \
  && apt-add-repository -y "ppa:git-core/ppa" \
  && apt-add-repository -y "ppa:neovim-ppa/stable" \
  && apt-get update -y \
  && apt-get install -y \
      jq fish git openssh-client emacs25 language-pack-en-base fontconfig neovim zip \
      'bitb=0.0.1-20200820010225-62eece1' \
  && update-ca-certificates

RUN git clone https://github.com/junegunn/fzf.git ~/.fzf \
  && cd ~/.fzf \
  && git checkout "315e568" \
  && ~/.fzf/install --all

ADD data tmp

RUN cp /tmp/entrypoint /usr/local/bin

RUN git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

RUN fish /tmp/install-oh-my-fish --path=~/.local/share/omf --config=~/.config/omf --noninteractive

RUN fish -c "omf install gitstatus bass"
