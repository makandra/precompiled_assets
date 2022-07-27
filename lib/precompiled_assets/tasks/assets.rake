require 'precompiled_assets/tasks'

namespace :assets do
  desc 'Empty task; assets should be compiled externally. Libraries like jsbundling-rails extend this task to do that.'
  task precompile: :environment do # rubocop:disable Lint/EmptyBlock
  end

  desc 'Remove all assets inside the compiled asset path, but keep the directory itself'
  task clobber: :environment do
    PrecompiledAssets::Tasks.remove_all
  end

  desc 'Remove all assets not linked in the current manifest file'
  task clean: :environment do
    PrecompiledAssets::Tasks.remove_unused
  end
end
