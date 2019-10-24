#!/bin/bash
### Simple script wraps invocation of emcc compiler, also prepares preprocessor
### for wasm binary lookup in node.js

# It is important call in forms of ./build.sh -o outputfilePath ...rest,
# as we'll pick up output filename from parameter
outputFilename=$(basename $2)

echo "building binary for $@"

# functions to be exported from hunspell
HUNSPELL_EXPORT_FUNCTIONS="[\
'_Hunspell_create',\
'_Hunspell_destroy',\
'_Hunspell_spell',\
'_Hunspell_suggest',\
'_Hunspell_free_list',\
'_Hunspell_add_dic',\
'_Hunspell_add',\
'_Hunspell_remove',\
'_Hunspell_add_with_affix']"

# additional runtime helper from emscripten
EXPORT_RUNTIME="[\
'cwrap',\
'stringToUTF8',\
'allocateUTF8', \
'getValue',\
'UTF8ToString']"

# invoke emscripten to build binary targets. Check Dockerfile for build targets.
em++ \
-O2 \
-s NO_EXIT_RUNTIME=1 \
-s ALLOW_MEMORY_GROWTH=1 \
-s MODULARIZE=1 \
-s ASSERTIONS=1 \
-s DYNAMIC_EXECUTION=0 \
-s SINGLE_FILE=1 \
-s EXPORTED_FUNCTIONS="$HUNSPELL_EXPORT_FUNCTIONS" \
-s EXTRA_EXPORTED_RUNTIME_METHODS="$EXPORT_RUNTIME" \
./src/hunspell/.libs/libhunspell-1.7.a \
--pre-js ./preprocessor.js \
$@