FROM ojkwon/arch-emscripten:704654c3-base

# Build time args
ARG BRANCH=""
ARG TARGET=""

RUN emcc -v
RUN echo building for $BRANCH

# Setup output path, checkout source
RUN mkdir -p /out && git clone https://github.com/hunspell/hunspell.git /hunspell-$TARGET/hunspell

# Copy source from host
COPY . /hunspell-$TARGET/

# Copy build script and preprocessor into hunspell directory
COPY ./build/preprocessor.js ./build/build.sh /hunspell-$TARGET/hunspell/

# Set workdir to hunspell
WORKDIR /hunspell-$TARGET/hunspell

# Checkout branch to build
RUN git checkout $BRANCH && git show --summary

# Configure & make via emscripten
RUN echo running autoconf && autoreconf -vfi
RUN echo running configure && emconfigure ./configure
RUN echo running make && emmake make

CMD echo dockerfile ready