FROM ojkwon/arch-emscripten:752ef5c

# Setup output / build source path
RUN mkdir -p /out/wasm && mkdir /out/js
RUN mkdir /hunspell

# Copy source with build script from host, set workdir
COPY ./hunspell /hunspell
COPY ./script/build.sh ./script/preprocessor* /hunspell/
WORKDIR /hunspell

# Configure & make via emscripten
RUN echo running autoconf && autoreconf -vfi
RUN echo running configure && emconfigure ./configure
RUN echo running make && emmake make

# Build for each target, WASM / JS (asm.js)
CMD ./build.sh -o /out/wasm/hunspell.js --pre-js ./preprocessor-wasm.js -s WASM=1 && \
    ./build.sh -o /out/js/hunspell.js   --pre-js ./preprocessor-asm.js