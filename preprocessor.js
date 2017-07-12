/**
  * Preprocessor script to be injected into compiled output
  *
  * In here, detect environment and if it's node, override `Module.locateFile`
  * (https://kripken.github.io/emscripten-site/docs/api_reference/module.html#Module.locateFile)
  * to use relative path for locating memory optimization file (.mem) or wasm binary (.wasm)
  * by default, it always look for current running directory.
  */

//Object asm runtime will use.
//Hoisting it earlier than actual runtime bootstrapping in preprocessor allows to create preinit hooks.
var Module = {};

// expose filesystem api
Module["preRun"] = function () {
  Module.FS = FS;
};

//Caching init value to resolve subsequent init runtime immediately.
var __hunspell_asm_module_isInitialized = false;

/**
 * Returns promise resolve once runtime initialized.
 */
Module["initializeRuntime"] = function () {
  if (__hunspell_asm_module_isInitialized) {
    return Promise.resolve(true);
  }

  return new Promise(function (resolve, reject) {
    var timeoutId = setTimeout(function () {
      resolve(false);
    }, 3000);

    Module["onRuntimeInitialized"] = function () {
      clearTimeout(timeoutId);
      __hunspell_asm_module_isInitialized = true;
      resolve(true);
    }
  });
}

//using module.exports to detect node environment
if (typeof module !== 'undefined' && module.exports) {
  if (typeof __dirname === "string") {
    Module["locateFile"] = function (fileName) {
      return require('path').join(__dirname, fileName);
    }

    //___wasm_binary_name___ is being replaced build time via build.sh
    //Module["wasmBinaryFile"] = require('path').join(__dirname, "___wasm_binary_name___.wasm");
  }
}