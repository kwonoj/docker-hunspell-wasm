FROM ojkwon/arch-chromium-code:master-20170623

# Accept release tag as param
ARG TAG

# Init emscripten
RUN /bin/bash -l -c "source /temp-python/bin/activate && emcc"

# Get latest code
RUN source /temp-python/bin/activate && gclient sync

# Get latest available tags, checkout tag
RUN git fetch --tags && \
  git checkout -b ${TAG}_work tags/$TAG && \
  git rev-parse --abbrev-ref HEAD

# Sync branches to checked out tag head
# https://www.chromium.org/developers/how-tos/get-the-code/working-with-release-branches
RUN source /temp-python/bin/activate && \
  gclient sync --with_branch_heads --jobs 16 && \
  gclient runhooks && \
  gn gen out/Default

# Build dependencies
RUN source /temp-python/bin/activate && \
  ninja -C out/Default third_party/hunspell:hunspell third_party/cld_3/src/src:cld_3

#/chromium/src/out/Default/obj/third_party/cld_3/src/src
#/chromium/src/out/Default/obj/third_party/hunspell

CMD echo DONE