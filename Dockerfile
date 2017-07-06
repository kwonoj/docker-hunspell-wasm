FROM ojkwon/arch-emscripten:752ef5c

# Configure buildtime argument
ARG BUILD_SHA

# Setup output path
RUN mkdir -p /out/wasm && mkdir /out/js && mkdir /out/html

# Clone repo, copy build script from host, set workdir
RUN git clone https://github.com/kwonoj/hunspell
COPY build.sh preprocessor.js /hunspell/
WORKDIR /hunspell

# Checkout custom branch's sha to build, injected when build time
RUN echo building commit ${BUILD_SHA} && git checkout $BUILD_SHA
RUN git show --summary

# Configure & make via emscripten
RUN echo running autoconf && autoreconf -vfi
RUN echo running configure && emconfigure ./configure
RUN echo running make && emmake make

# Build for each target, WASM / JS / HTML (HTML is for testing)
CMD ./build.sh -o /out/wasm/hunspell.js -s WASM=1 --pre-js ./preprocessor.js && \
  ./build.sh -o /out/js/hunspell.js && \
  ./build.sh -o /out/html/hunspell.html