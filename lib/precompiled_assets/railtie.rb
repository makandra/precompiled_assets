require 'rails'

module PrecompiledAssets
  class Railtie < ::Rails::Railtie

    config.after_initialize do
      ActiveSupport.on_load(:action_view) do
        require 'precompiled_assets/helper'
        include PrecompiledAssets::Helper
      end
    end

    rake_tasks do
      load 'precompiled_assets/tasks/assets.rake'
    end

  end
end
