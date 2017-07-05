# it is important call in forms of ./build.sh -o outputfilePath ...resg
outputFilename=$(basename $2)

# injecting -o option's filename.wasm into preprocessor
sed -i -e "s/___wasm_binary_name___/${outputFilename%.*}.wasm/g" ./preprocessor.js

# invokce emscripten to build binary targets configured via dockerfile.
em++ \
-O3 \
-Oz \
--llvm-lto 1 \
-s NO_EXIT_RUNTIME=1 \
-s ALLOW_MEMORY_GROWTH=1 \
-s EXPORTED_RUNTIME_METHODS="['FS_createFolder', 'FS_createPath',  'FS_createDataFile',  'FS_createPreloadedFile',  'FS_createLazyFile',  'FS_createLink', 'FS_createDevice',  'FS_unlink',  'Runtime',  'ccall',  'cwrap',  'setValue',  'getValue',  'ALLOC_NORMAL',  'ALLOC_STACK',  'ALLOC_STATIC',  'ALLOC_DYNAMIC',  'ALLOC_NONE',  'allocate',  'getMemory',  'Pointer_stringify',  'AsciiToString',  'stringToAscii',  'UTF8ArrayToString',  'UTF8ToString',  'stringToUTF8Array',  'stringToUTF8',  'lengthBytesUTF8',  'stackTrace',  'addOnPreRun',  'addOnInit',  'addOnPreMain',  'addOnExit',  'addOnPostRun',  'intArrayFromString',  'intArrayToString',  'writeStringToMemory',  'writeArrayToMemory',  'writeAsciiToMemory',  'addRunDependency',  'removeRunDependency',  'UTF32ToString',  'stringToUTF32', 'UTF16ToString',  'stringToUTF16']" \
-s EXPORTED_FUNCTIONS="['_Hunspell_create', '_Hunspell_destroy', '_Hunspell_spell', '_Hunspell_suggest']" \
./src/hunspell/.libs/libhunspell-1.6.a \
--pre-js ./preprocessor.js \
$@