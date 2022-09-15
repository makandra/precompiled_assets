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

If your application uses Sprockets, remove `sprockets-rails` (and possibly `sprockets`) from your `Gemfile` as well as any corresponding initializers, `require` statements, and the `config.assets` configuration settings.

## Usage

### Configuration

In your `config/application.rb`, configure an `asset_path` which should be in your `public/` directory:

```ruby
config.asset_path = '/assets'
```

For the `test` environment, you may want to use a separate path, i.e. in your `config/environments/test.rb` say:

```ruby
config.asset_path = '/assets-test'
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

The [esbuild-manifest-plugin](https://www.npmjs.com/package/esbuild-manifest-plugin) is one way to generate such a manifest during your build process.

Once that is set up, `javascript_include_tag('application.js')` or `image_path('example.png')` will resolve to their digested filenames and paths.

In the `development` Rails environment, the gem detects changes to the manifest and reloads the manifest automatically.
Hence, your development experience should be similar to other stacks, like with Propshaft or esbuild: You change assets, the manifest changes, Rails will then resolve to the updated asset paths. 🎉

### Accessing manifest or resolver manually

In views, you can use the helper method `asset_resolver` to access the (cached) resolver instance.
Otherwise, instantiate via `PrecompiledAssets::Resolver.new`.

To resolve an asset path, use `Resolver#resolve`:
```ruby
resolver = PrecompiledAssets::Resolver.new
resolver.resolve('application.js')
# => "/assets/application-HP2LS2UH.js"
```

If you want to know if assets were updated (e.g. when using etags), use `Manifest#updated_at`:
```ruby
resolver = PrecompiledAssets::Resolver.new
resolver.manifest.updated_at
# => (returns a Time instance)
```

Side note: `Manifest#updated_at` reads its modification time from the file system. If your production environments use a distributed file system, it is not recommended to use for etagging in production.


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Roadmap

1. Add tests
2. Integrate into more existing applications to discover new features that we might need.


## Contributing

I am very eager to keep this gem lightweight and on topic.
If you are unsure whether a change would make it into the gem, please create an issue and discuss first.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
