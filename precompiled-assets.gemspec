$LOAD_PATH.push File.expand_path('lib', __dir__)
require_relative 'lib/precompiled_assets/version'

Gem::Specification.new do |spec|
  spec.name = 'precompiled_assets'
  spec.version = PrecompiledAssets::VERSION
  spec.authors = ['Arne Hartherz']
  spec.email = ['arne.hartherz@makandra.de']

  spec.summary = 'Serve assets without any asset processing in Rails.'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/makandra/precompiled_assets'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'
  spec.metadata = {
    'rubygems_mfa_required' => 'true',
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/CHANGELOG.md",
  }

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r(\Aexe/)) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'railties', '>= 6.0.0'
end
