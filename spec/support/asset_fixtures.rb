require 'fileutils'
require 'json'
require 'pathname'

# Filesystem helpers for writing manifests and digested asset files into the
# test app's `public/assets-test/` directory. `clean` is invoked before every
# example so each spec starts with an empty asset directory.
module AssetFixtures

  module_function

  def root
    Pathname.new(TEST_APP_ROOT).join('public', 'assets-test')
  end

  def clean
    FileUtils.rm_rf(root)
    FileUtils.mkdir_p(root)
  end

  def write_manifest(mapping, filename = 'manifest.json')
    write_raw_manifest(JSON.dump(mapping), filename)
  end

  def write_raw_manifest(contents, filename = 'manifest.json')
    path = root.join(filename)
    path.write(contents)
    path
  end

  def write_asset(relative_path, contents = '')
    path = root.join(relative_path)
    FileUtils.mkdir_p(path.dirname)
    path.write(contents)
    path
  end

  def bump_mtime(path, seconds: 60)
    future = Time.now + seconds
    File.utime(future, future, path)
  end

end

RSpec.configure do |config|
  config.around do |example|
    AssetFixtures.clean
    example.run
  end
end
