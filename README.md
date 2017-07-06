# docker-hunspell-bdict-wasm

# Building / Testing

CI server (`.circleci/config.yml`) runs actual build script, while Dockerfile serves as base image for running build script.


# Clone repo, copy build script from host, set workdir
RUN git clone https://github.com/kwonoj/hunspell
WORKDIR /hunspell

CMD git show --summary

# Setup output path
RUN mkdir -p /out/wasm && mkdir /out/js && mkdir /out/html

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