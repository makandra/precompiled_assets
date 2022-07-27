module PrecompiledAssets
  class Resolver

    class Error < PrecompiledAssets::Error; end
    class UnknownAsset < Error; end

    def resolve(path)
      reload_manifest if Rails.env.development? && manifest.expired?

      digested_path = manifest.resolve(path.to_s)

      if digested_path.present?
        File.join(Rails.configuration.asset_path, digested_path)
      else
        raise UnknownAsset, "Could not find #{path.inspect} in manifest: #{manifest.inspect}"
      end
    end

    def manifest
      @manifest ||= Manifest.new
    end

    def reload_manifest
      @manifest = nil
      manifest
    end

  end
end
