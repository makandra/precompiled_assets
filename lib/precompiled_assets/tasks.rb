module PrecompiledAssets
  module Tasks

    module_function

    def remove_all
      LocalPath.pathname.glob('*').each(&:rmtree)
    end

    def remove_unused
      manifest = Manifest.new

      pathnames = LocalPath.pathname.glob('**/*').sort

      # Remove all files not listed in the manifest; also keep the manifest file itself.
      pathnames.select(&:file?).each do |asset_pathname|
        next if manifest.pathname == asset_pathname
        next if manifest.includes_digested_path?(asset_pathname)
        next if manifest.includes_digested_path?(asset_pathname.to_s.delete_suffix('.map'))

        puts "Removing unused asset: #{asset_pathname}"
        asset_pathname.delete
      end

      # After removing all unused files, remove any empty directories that remain.
      # Iterating in reverse to start with most deeply nested directories first, allow to clean up empty branches.
      pathnames.select(&:directory?).reverse_each do |directory|
        next unless directory.empty?

        puts "Removing empty directory: #{directory}"
        directory.rmdir
      end
    end

  end
end
