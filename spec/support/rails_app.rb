# Boots a minimal in-process Rails application so the specs can exercise the
# gem's Rails integration (Railtie, helper inclusion, `Rails.configuration`)
# without an on-disk dummy app.
#
# Layout on disk:
#
#   <gem-root>/tmp/spec_app/
#   └── public/
#       └── assets-test/   ← AssetFixtures reads and writes here
#
# Ordering matters in this file:
#   1. Load Rails + the frameworks we want included in the test app.
#   2. Load ViewComponent optionally (present only in Gemfile.viewcomponent-4)
#      so its `on_load(:view_component)` hook is registered before the gem's
#      Railtie runs `config.after_initialize`.
#   3. Require the gem itself so `PrecompiledAssets::Railtie` hooks into Rails
#      *before* `initialize!` fires the after_initialize callbacks.
#   4. Define the application and call `initialize!`.

require 'fileutils'
require 'logger'
require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'

if Gem.loaded_specs.include?('view_component')
  # Only the viewcomponent-4 matrix gemfile installs this.
  require 'view_component'
end

TEST_APP_ROOT = File.expand_path('../../tmp/spec_app', __dir__)

FileUtils.rm_rf(TEST_APP_ROOT)
FileUtils.mkdir_p(File.join(TEST_APP_ROOT, 'public', 'assets-test'))

require 'precompiled_assets'
# Tasks is loaded lazily by the rake file in production; require it eagerly
# so specs can call `PrecompiledAssets::Tasks.remove_unused` without going
# through Rake.
require 'precompiled_assets/tasks'

module TestApp
  class Application < ::Rails::Application
    config.root = TEST_APP_ROOT
    config.eager_load = false
    config.logger = Logger.new(IO::NULL)
    config.secret_key_base = 'test-secret-key-base'
    config.asset_path = '/assets-test'
  end
end

TestApp::Application.initialize!
Rails.application.load_tasks
