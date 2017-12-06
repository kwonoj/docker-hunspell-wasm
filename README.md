# hunspell

This folder contains source code of hunspell with script / configuration to build wasm target build.

Check dockerfile for base build configurations, and check [circleci config](https://github.com/kwonoj/hunspell-bdict-wasm/blob/master/.circleci/config.yml) for build commands.

To create release, simply create git tag and push into remote. CircleCI's `release` job will upload release build automatically.