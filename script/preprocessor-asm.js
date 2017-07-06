/**
 * Preprocessor script to be injected into compiled output
 *
 * In here, detect environment and if it's node, override `Module.localteFile`
 * (https://kripken.github.io/emscripten-site/docs/api_reference/module.html#Module.locateFile)
 * to use relative path for locating memory optimization file (.mem)
 * by default, it always look for current running directory.
 */

//using module.exports to detect node environment
if (typeof module !== 'undefined' && module.exports) {
  var Module = {};
  if (typeof __dirname === "string") {
    //___asm_memfile_name___ is being replaced build time via build.sh
    Module["locateFile"] = function () {
      return require('path').join(__dirname, "___asm_memfile_name___.js.mem");
    }
  }
}
