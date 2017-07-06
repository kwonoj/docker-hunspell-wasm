FROM ojkwon/arch-nvm-node:4032238-node7.9-npm4

# Install dependencies
RUN pacman --noconfirm -Sy \
  emscripten \
  python \
  jre8-openjdk

# Change subsequent execution shell to bash
SHELL ["/bin/bash", "-l", "-c"]

# Initialize emcc
RUN emcc

CMD emcc --version