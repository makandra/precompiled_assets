module PrecompiledAssets
  class Manifest

    DEFAULT_FILENAME = 'manifest.json'.freeze

    class Error < PrecompiledAssets::Error; end
    class NotFound < Error; end
    class ParseError < Error; end

    def resolve(path)
      parsed_manifest[path]
    end

    def pathname
      @pathname ||= LocalPath.pathname.join(filename)
    end

    def includes_digested_path?(path_or_pathname)
      digested_paths.include?(path_or_pathname.to_s)
    end

    def updated_at
      # Not intended for use in production environments.
      mtime || fetch_mtime
    end

    def expired?
      # Not intended for use in production environments.
      mtime && mtime != fetch_mtime
    end

    private

    attr_accessor :mtime

    def filename
      Rails.configuration.try(:asset_manifest_filename) || DEFAULT_FILENAME
    end

    def parsed_manifest
      @parsed_manifest ||= parse_manifest
    end

    def parse_manifest
      raise NotFound, "Manifest not found at #{pathname}" unless pathname.exist?

      self.mtime = fetch_mtime

      json = pathname.read
      JSON.parse(json)
    rescue JSON::ParserError => error
      raise ParseError, "Failed to parse manifest file: #{error.message}"
    end

    def fetch_mtime
      File.mtime(pathname)
    end

    def digested_paths
      @digested_paths ||= parsed_manifest
        .values
        .map { |asset_path| LocalPath.pathname.join(asset_path).to_s }
    end

  end
end
