FROM ojkwon/arch-emscripten:752ef5c

# Setup output / build source path
RUN mkdir -p /out && mkdir /hunspell

# Set workdir
WORKDIR /hunspell

# Copy source with build script from host, set workdir
COPY ./hunspell-bdict ./preprocessor* /hunspell/

# Configure & make via emscripten
RUN echo running autoconf && autoreconf -vfi
RUN echo running configure && emconfigure ./configure
RUN echo running make && emmake make

# Build wasm target output.
#
# Why no asm.js target? : Interestingly, asm.js target fails to get correct suggestion via Hunspell::suggest.
# My best guess so far is it have different behavior due to memory alignment issue
# (https://kripken.github.io/emscripten-site/docs/porting/Debugging.html?highlight=alignment#memory-alignment-issues)
# through reinterpret_cast around codebases. (asm.js only issue, not on wasm. https://github.com/kripken/emscripten/issues/4760#issuecomment-263750870)
# As it's not immediate goal to provide polyfill-behavior for non-wasm-supported targets, only build wasm instead.
CMD em++ \
    -O3 \
    -Oz \
    --llvm-lto 1 \
    --pre-js ./preprocessor-wasm.js \
    -s WASM=1 \
    -s NO_EXIT_RUNTIME=1 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s EXPORTED_FUNCTIONS="['_Hunspell_create', '_Hunspell_destroy', '_Hunspell_spell', '_Hunspell_suggest']" \
    ./src/hunspell/.libs/libhunspell-1.6.a \
    -o /out/hunspell.js

# disable closure optimization for now
# --closure 1 \