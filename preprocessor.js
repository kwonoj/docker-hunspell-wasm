/**
  * Preprocessor script to be injected into compiled output
  *
  * In here, detect environment and if it's node, override `Module.locateFile`
  * (https://kripken.github.io/emscripten-site/docs/api_reference/module.html#Module.locateFile)
  * to use relative path for locating memory optimization file (.mem)
  * by default, it always look for current running directory.
  */

//using module.exports to detect node environment
if (typeof module !== 'undefined' && module.exports) {
  var Module = {};
  if (typeof __dirname === "string") {
    Module["locateFile"] = function (fileName) {
      return require('path').join(__dirname, fileName);
    }

    //___wasm_binary_name___ is being replaced build time via build.sh
    //Module["wasmBinaryFile"] = require('path').join(__dirname, "___wasm_binary_name___.wasm");
  }

  // expose filesystem api
  Module["preRun"] = function () {
    Module.FS = FS;
  };

  var isInitialized = false;

  // expose initializeRuntime to allow wait runtime init
  Module["initializeRuntime"] = function () {
    if (isInitialized) {
      return Promise.resolve(true);
    }

    return new Promise(function (resolve, reject) {
      var timeoutId = setTimeout(function () {
        resolve(false);
      }, 3000);

      Module["onRuntimeInitialized"] = function () {
        clearTimeout(timeoutId);
        isInitialized = true;
        resolve(true);
      }
    });
  }
}