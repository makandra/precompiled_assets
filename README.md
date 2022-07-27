# PrecompiledAssets

Serve assets without any asset processing in Rails. 

The gem is intended for applications where assets are digested externally, e.g. via esbuild.

Our only requirements are
- a manifest file which needs to be generated during the build process,
- that the manifest lives somewhere inside `public/` (you are free to configure an `asset_host`, won't affect the gem),
- and a matching Rails configuration setting.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add precompiled_assets

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install precompiled_assets

## Usage

In your `config/application.rb`, configure an `asset_path` which should be in your `public/` directory:

```ruby
config.asset_path = '/assets'
```

Inside that path, a `manifest.json` is expected to exist which resolves your undigested input names to digested output paths.
If your manifest has a different filename, you may set `config.asset_manifest_filename`.

A manifest file can look like this:

```json
{
  "application.js": "application-HP2LS2UH.js",
  "application.css": "application-BWAZLURC.css",
  "images/example.png": "images/example-5N2N2WJM.png"
}
```

Once that is set up, `javascript_include_tag('application.js')` or `image_path('example.png')` will resolve to their digested filenames and paths.

In the `development` Rails environment, the gem detects changes to the manifest and reloads the manifest automatically.
Hence, your development experience should be similar to other stacks, like with Propshaft or esbuild: You change assets, the manifest changes, Rails will then resolve to the updated asset paths. 🎉



## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

I am very eager to keep this gem lightweight and on topic.
If you are unsure whether a change would make it into the gem, please create an issue and discuss first.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
