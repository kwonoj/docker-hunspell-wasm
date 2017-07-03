FROM ojkwon/arch-nvm-node:4032238-node7.9-npm4

# Configure buildtime argument
ARG BUILD_SHA

# Install dependencies
RUN pacman --noconfirm -Sy \
  emscripten \
  python \
  jre8-openjdk

# Change subsequent execution shell to bash
SHELL ["/bin/bash", "-l", "-c"]

# Initialize emcc
RUN emcc

# Setup output path
RUN mkdir -p /out/wasm && mkdir /out/js && mkdir /out/html

# Clone repo, copy build script from host, set workdir
RUN git clone https://github.com/kwonoj/hunspell
COPY build.sh preprocessor.js /hunspell/
WORKDIR /hunspell

# Checkout custom branch's sha to build, injected when build time
RUN git checkout $BUILD_SHA && echo building commit ${BUILD_SHA}
RUN git show --summary

# Configure & make via emscripten
RUN autoreconf -vfi && emconfigure ./configure && emmake make

# Build for each target, WASM / JS / HTML (HTML is for testing)
CMD ./build.sh -o /out/wasm/hunspell.js -s WASM=1 && \
  ./build.sh -o /out/js/hunspell.js && \
  ./build.sh -o /out/html/hunspell.html