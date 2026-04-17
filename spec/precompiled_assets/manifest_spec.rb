describe PrecompiledAssets::Manifest do
  subject(:manifest) { described_class.new }

  describe '#resolve' do
    before do
      AssetFixtures.write_manifest(
        'application.js' => 'application-HP2LS2UH.js',
        'images/example.png' => 'images/example-5N2N2WJM.png',
      )
    end

    it 'returns the digested path for a known entry' do
      expect(manifest.resolve('application.js')).to eq('application-HP2LS2UH.js')
    end

    it 'returns the digested path for a nested entry' do
      expect(manifest.resolve('images/example.png')).to eq('images/example-5N2N2WJM.png')
    end

    it 'returns nil for unknown entries' do
      expect(manifest.resolve('missing.js')).to be_nil
    end

    it 'raises NotFound when the manifest file is missing' do
      AssetFixtures.clean

      expect { manifest.resolve('application.js') }
        .to raise_error(PrecompiledAssets::Manifest::NotFound, /Manifest not found/)
    end

    it 'raises ParseError for malformed JSON' do
      AssetFixtures.clean
      AssetFixtures.write_raw_manifest('{not valid json')

      expect { manifest.resolve('application.js') }
        .to raise_error(PrecompiledAssets::Manifest::ParseError, /Failed to parse manifest/)
    end

    it 'skips caching and retries parsing on a subsequent call after a ParseError' do
      AssetFixtures.clean
      AssetFixtures.write_raw_manifest('{not valid json')

      expect { manifest.resolve('application.js') }
        .to raise_error(PrecompiledAssets::Manifest::ParseError)

      AssetFixtures.write_manifest('application.js' => 'application-HP2LS2UH.js')

      expect(manifest.resolve('application.js')).to eq('application-HP2LS2UH.js')
    end
  end

  describe '#pathname' do
    it 'joins the configured asset path with the default manifest filename' do
      expect(manifest.pathname.to_s).to end_with('/public/assets-test/manifest.json')
    end

    context 'with a custom asset_manifest_filename' do
      around do |example|
        original = Rails.configuration.try(:asset_manifest_filename)
        Rails.configuration.asset_manifest_filename = 'assets.json'
        example.run
      ensure
        Rails.configuration.asset_manifest_filename = original
      end

      it 'uses the custom filename' do
        expect(manifest.pathname.to_s).to end_with('/public/assets-test/assets.json')
      end
    end
  end

  describe '#includes_digested_path?' do
    let(:digested_path) { AssetFixtures.root.join('application-HP2LS2UH.js') }

    before do
      AssetFixtures.write_manifest('application.js' => 'application-HP2LS2UH.js')
    end

    it 'matches a digested path passed as a string' do
      expect(manifest.includes_digested_path?(digested_path.to_s)).to be true
    end

    it 'matches a digested path passed as a Pathname' do
      expect(manifest.includes_digested_path?(digested_path)).to be true
    end

    it 'returns false for paths not listed in the manifest' do
      expect(manifest.includes_digested_path?('unknown.js')).to be false
    end
  end

  describe '#updated_at' do
    it 'returns the manifest file mtime' do
      path = AssetFixtures.write_manifest('application.js' => 'application-HP2LS2UH.js')
      expect(manifest.updated_at).to eq(path.mtime)
    end

    it 'caches the mtime after the manifest has been parsed' do
      path = AssetFixtures.write_manifest('application.js' => 'application-HP2LS2UH.js')
      manifest.resolve('application.js')
      cached_mtime = path.mtime

      AssetFixtures.bump_mtime(path)

      expect(manifest.updated_at).to eq(cached_mtime)
    end
  end

  describe '#expired?' do
    let!(:path) do
      AssetFixtures.write_manifest('application.js' => 'application-HP2LS2UH.js')
    end

    it 'is false right after the manifest has been loaded' do
      manifest.resolve('application.js')
      expect(manifest).not_to be_expired
    end

    it 'is true after the manifest file has been modified' do
      manifest.resolve('application.js')

      AssetFixtures.bump_mtime(path)

      expect(manifest).to be_expired
    end

    it 'is falsy when the manifest has not been loaded yet' do
      expect(manifest).not_to be_expired
    end
  end
end
