FROM ojkwon/arch-emscripten:752ef5c

# Configure buildtime argument
ARG BUILD_SHA

# Setup output path
RUN mkdir -p /out/wasm && mkdir /out/js

# Clone repo, copy build script from host, set workdir
RUN git clone https://github.com/kwonoj/hunspell
COPY ./script/build.sh ./script/preprocessor* /hunspell/
WORKDIR /hunspell

# Checkout custom branch's sha to build, injected when build time
RUN echo building commit ${BUILD_SHA} && git checkout $BUILD_SHA
RUN git show --summary

# Configure & make via emscripten
RUN echo running autoconf && autoreconf -vfi
RUN echo running configure && emconfigure ./configure
RUN echo running make && emmake make

# Build for each target, WASM / JS (asm.js)
CMD ./build.sh -o /out/wasm/hunspell.js --pre-js ./preprocessor-wasm.js -s WASM=1 && \
    ./build.sh -o /out/js/hunspell.js   --pre-js ./preprocessor-asm.js