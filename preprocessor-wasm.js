/**
 * Preprocessor script to be injected into compiled output
 *
 * In here, detect environment and if it's node, override `Module.wasmBinaryFile`
 * to use relative path - by default, it always look for current running directory.
 * https://github.com/kripken/emscripten/pull/5296 will allow embed everything into
 * single file, which'll be solution for this.
 */

//using module.exports to detect node environment
if (typeof module !== 'undefined' && module.exports) {
  var Module = {};
  if (typeof __dirname === "string") {
    //___wasm_binary_name___ is being replaced build time via build.sh
    Module["wasmBinaryFile"] = require('path').join(__dirname, "___wasm_binary_name___.wasm");
  }
  // expose filesystem
  Module['preRun'] = function () {
    Module.FS = FS;
  };
}
