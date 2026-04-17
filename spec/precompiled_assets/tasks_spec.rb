describe PrecompiledAssets::Tasks do
  describe '.remove_all' do
    it 'removes all files and subdirectories inside the asset path' do
      AssetFixtures.write_manifest('application.js' => 'application-HP2LS2UH.js')
      AssetFixtures.write_asset('application-HP2LS2UH.js')
      AssetFixtures.write_asset('images/logo-ABC.png')

      silence_stdout { described_class.remove_all }

      expect(AssetFixtures.root.glob('*')).to be_empty
    end

    it 'keeps the asset directory itself' do
      silence_stdout { described_class.remove_all }
      expect(AssetFixtures.root).to exist
    end
  end

  describe '.remove_unused' do
    before do
      AssetFixtures.write_manifest(
        'application.js' => 'application-HP2LS2UH.js',
        'images/logo.png' => 'images/logo-ABC.png',
      )
    end

    it 'keeps files listed in the manifest' do
      AssetFixtures.write_asset('application-HP2LS2UH.js', 'some content')
      AssetFixtures.write_asset('images/logo-ABC.png', 'more content')

      silence_stdout { described_class.remove_unused }

      expect(AssetFixtures.root.join('application-HP2LS2UH.js')).to exist
      expect(AssetFixtures.root.join('images/logo-ABC.png')).to exist
    end

    it 'keeps the manifest file itself' do
      silence_stdout { described_class.remove_unused }

      expect(AssetFixtures.root.join('manifest.json')).to exist
    end

    it 'removes files not listed in the manifest' do
      AssetFixtures.write_asset('orphan-OLD.js', 'stale')

      silence_stdout { described_class.remove_unused }

      expect(AssetFixtures.root.join('orphan-OLD.js')).not_to exist
    end

    it 'keeps source maps that belong to a listed file' do
      AssetFixtures.write_asset('application-HP2LS2UH.js', 'content')
      AssetFixtures.write_asset('application-HP2LS2UH.js.map', 'map')

      silence_stdout { described_class.remove_unused }

      expect(AssetFixtures.root.join('application-HP2LS2UH.js.map')).to exist
    end

    it 'removes source maps whose source file is not listed' do
      AssetFixtures.write_asset('orphan-OLD.js.map', 'map')

      silence_stdout { described_class.remove_unused }

      expect(AssetFixtures.root.join('orphan-OLD.js.map')).not_to exist
    end

    it 'removes empty directories left behind after deletion' do
      AssetFixtures.write_asset('old/nested/orphan.js', 'stale')

      silence_stdout { described_class.remove_unused }

      expect(AssetFixtures.root.join('old/nested')).not_to exist
      expect(AssetFixtures.root.join('old')).not_to exist
    end

    it 'keeps directories that still contain listed files' do
      AssetFixtures.write_asset('images/logo-ABC.png', 'content')

      silence_stdout { described_class.remove_unused }

      expect(AssetFixtures.root.join('images')).to exist
    end
  end
end
