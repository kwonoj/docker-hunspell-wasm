# invokce emscripten to build binary targets configured via dockerfile.

em++ \
-O3 \
-Oz \
--llvm-lto 1 \
-s NO_EXIT_RUNTIME=1 \
-s EXPORTED_FUNCTIONS="['_Hunspell_create', '_Hunspell_destroy', '_Hunspell_spell']" \
./src/hunspell/.libs/libhunspell-1.6.a \
$@