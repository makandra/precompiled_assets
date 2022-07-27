module PrecompiledAssets
  module LocalPath

    module_function

    def pathname
      joinable_asset_path = Rails.configuration.asset_path.delete_prefix('/')
      Rails.public_path.join(joinable_asset_path)
    end

  end
end
