# SDL3

SDL3 bindings for crystal

## Installation

(Ideally in the future, maybe i make a script to do this that gets ran during `shards install` for each platform macOS, Windows, Linux and keeps SDL3 and external libs inside the lib folder, abstracted away from the dev user's operating system, but for now you'll need to do it manually.)

Install SDL3 and other external libs SDL3_tty, SDL3_image

(You can see the exact versions in the `shard.yml` file in this repo)

### macOS:

```
brew install sdl3 sdl3_image sdl3_ttf
```

### linux

see the [SDL3 wiki Linux](https://wiki.libsdl.org/SDL3/README-linux) instructions

### SDL3_mixer installation

you'll also need to separately install / unzip [SDL3_Mixer](https://wiki.libsdl.org/SDL3_mixer)([release](https://github.com/libsdl-org/SDL_mixer/releases))

currently only from the Github releases, hopefully package managers will pick it up when it's out of prerelease

1. unzip it to a local folder like `~/ext_libs` 
2. modify `~/.zshrc` or bash shell to include it to some env vars:

```
# SDL3_mixer manual installation
export C_INCLUDE_PATH="$HOME/ext_libs/sdl3_mixer/include:$C_INCLUDE_PATH"
export LIBRARY_PATH="$HOME/ext_libs/sdl3_mixer/lib:$LIBRARY_PATH"
export PKG_CONFIG_PATH="$HOME/ext_libs/sdl3_mixer/lib/pkgconfig:$PKG_CONFIG_PATH"
export DYLD_LIBRARY_PATH="$HOME/ext_libs/sdl3_mixer/lib:$DYLD_LIBRARY_PATH"
```

3. tweak sdl3.cr `Makefile`

since I added the `--link-flags` in the sdl3.cr `Makefile`, you'll want to tweak:

```
SDL3_MIXER_LIB_DIR := /Users/matt/ext_libs/sdl3_mixer/lib
```

so it lines up with where you unzipped SDL3_mixer

### Install Shards

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     sdl3:
       github: mswieboda/sdl3.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "sdl3"
```

## NOTE

These bindings are work in progress, but mostly complete, definitely enough to use.

But it should always be in working order, so the latest can be used in crystal to access SDL3

## Contributing

1. Fork it (<https://github.com/your-github-user/sdl3/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Matt Swieboda](https://github.com/mswieboda) - creator and maintainer
