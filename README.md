# SDL3

SDL3 bindings for crystal

## Installation

1. Install SDL3 and other external libs SDL3_tty, SDL3_image

(You can see the exact versions in the `shard.yml` file in this repo)

On a Mac:

```
brew install sdl3 sdl3_image sdl3_ttf
```

2. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     sdl3:
       github: your-github-user/sdl3
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
