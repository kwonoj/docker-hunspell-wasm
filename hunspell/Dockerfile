FROM ojkwon/arch-nvm-node:4032238-node7.9-npm4

# Install dependencies
RUN pacman --noconfirm -Sy \
  emscripten \
  jre8-openjdk

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH=`pwd`/depot_tools:"$PATH"

RUN mkdir ~/chromium && cd chromium && fetch --nohooks chromium
WORKDIR chromium/src
CMD gn gen out/Default