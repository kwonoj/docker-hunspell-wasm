# it is important call in forms of ./build.sh -o outputfilePath ...resg
outputFilename=$(basename $2)

# injecting -o option's filename.wasm into preprocessor
sed -i -e "s/___wasm_binary_name___/${outputFilename%.*}.wasm/g" ./preprocessor.js

# invokce emscripten to build binary targets configured via dockerfile.
em++ \
-O3 \
-Oz \
--llvm-lto 1 \
--closure 1 \
-s NO_EXIT_RUNTIME=1 \
-s EXPORTED_FUNCTIONS="['_Hunspell_create', '_Hunspell_destroy', '_Hunspell_spell', '_Hunspell_suggest']" \
./src/hunspell/.libs/libhunspell-1.6.a \
--pre-js ./preprocessor.js \
$@