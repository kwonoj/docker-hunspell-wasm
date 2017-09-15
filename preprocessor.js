/**
  * Preprocessor script to be injected into compiled output
  *
  */

// preprocessor attached into asm loader context has `Module` predefined.


// Electron's renderer process is special environment that emscripten can't detect correctly if module loader
// would like to use node.js context (overriding context via ENVIRONMENT==='NODE' but doesn't provide endpoint via locateFile override)
// cause emscripten's getBinaryPromise simply checks existence of `fetch` api. In here, do global object patching while init module
// if given config is set to use NODE but process is actually Electron.
var originalFetch = null;
if (Module["ENVIRONMENT"] === "NODE" && !!window && !!window.process && !!window.require && !!window.fetch) {
  originalFetch = window.fetch;
  window.fetch = null;
}

// expose filesystem api selectively
Module["preRun"] = function () {
  //restore fetch context once wasm binary is loaded
  if (!!originalFetch) {
    window.fetch = originalFetch;
    originalFetch = null;
  }

  Module.FS = {
    filesystems: FS.filesystems,
    stat: FS.stat,
    isDir: FS.isDir,
    isFile: FS.isFile,
    mkdir: FS.mkdir,
    mount: FS.mount,
    writeFile: FS.writeFile,
    unlink: FS.unlink,
    unmount: FS.unmount,
    rmdir: FS.rmdir
  };
};