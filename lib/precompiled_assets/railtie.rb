require 'rails'

module PrecompiledAssets
  class Railtie < ::Rails::Railtie

    config.after_initialize do
      require 'precompiled_assets/helper'

      [:action_view, :view_component].each do |framework|
        ActiveSupport.on_load(framework) do
          include PrecompiledAssets::Helper
        end
      end
    end

    rake_tasks do
      load 'precompiled_assets/tasks/assets.rake'
    end

  end
end
