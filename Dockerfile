FROM ojkwon/arch-nvm-node:4032238-node7.9-npm4

# Install dependencies
RUN pacman --noconfirm -Sy \
  emscripten \
  jre8-openjdk

RUN em++

RUN git clone https://github.com/hunspell/hunspell.git
COPY . ./hunspell
WORKDIR hunspell
RUN mkdir ./out_wasm && mkdir ./out_wasm_html

RUN git checkout v1.6.0
RUN curl https://chromium.googlesource.com/chromium/src/+/60.0.3112.41/third_party/hunspell/google.patch\?format\=TEXT | base64 -d > google.patch
RUN git apply google.patch

RUN autoreconf -vfi && emconfigure ./configure && emmake make
RUN ./build.sh ./out_wasm/hunspell.js
RUN ./build.sh ./out_wasm_html/hunspell.html
CMD ls ./out_wasm && ls ./out_wasm_html