module PrecompiledAssets
  module Helper

    ASSET_DIRECTORIES = ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES.except(:javascript, :stylesheet).freeze

    def asset_resolver
      Thread.current['PrecompiledAssets::Helper#asset_resolver'] ||= Resolver.new
    end

    def compute_asset_path(path, options = {})
      directory = ASSET_DIRECTORIES[options[:type]]
      path_with_directory = File.join(*directory, path)

      asset_resolver.resolve(path_with_directory.delete_prefix('/'))
    end

  end
end
