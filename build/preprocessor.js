/**
  * Preprocessor script to be injected into compiled output
  *
  */

// preprocessor attached into asm loader context has `Module` predefined.

// expose filesystem api selectively
Module["preRun"] = function () {
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