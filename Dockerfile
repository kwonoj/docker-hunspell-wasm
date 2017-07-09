FROM ojkwon/arch-emscripten:752ef5c

# Build time args
ARG BRANCH=""
ARG TARGET=""

RUN echo building for $BRANCH

# Setup output / build source path
RUN mkdir -p /out/$BRANCH/$TARGET && mkdir /hunspell-$TARGET

# Copy source host
COPY . /hunspell-$TARGET/

# Copy build script and preprocess into hunspell directory
COPY ./preprocessor* ./build.sh /hunspell-$TARGET/hunspell/

# Set workdir to hunspell
WORKDIR /hunspell-$TARGET/hunspell

# Checkout branch to build
RUN git checkout $BRANCH && git show --summary

# Configure & make via emscripten
RUN echo running autoconf && autoreconf -vfi
RUN echo running configure && emconfigure ./configure
RUN echo running make && emmake make

# Build target output. TARGET is runtime args.
CMD echo building $TARGET && \
    ./build.sh \
    -o /out/$(git describe --tags)/$TARGET/hunspell.js \
    --pre-js ./preprocessor-$TARGET.js \
    $([[ $TARGET = "wasm" ]] && echo "-s WASM=1" || echo "")