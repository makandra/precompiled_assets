describe PrecompiledAssets::Resolver do
  subject(:resolver) { described_class.new }

  before do
    AssetFixtures.write_manifest(
      'application.js' => 'application-HP2LS2UH.js',
    )
  end

  describe '#resolve' do
    it 'prefixes the digested path with the configured asset path' do
      expect(resolver.resolve('application.js')).to eq('/assets-test/application-HP2LS2UH.js')
    end

    it 'accepts a Pathname argument' do
      expect(resolver.resolve(Pathname.new('application.js')))
        .to eq('/assets-test/application-HP2LS2UH.js')
    end

    it 'raises UnknownAsset when the path is not in the manifest' do
      expect { resolver.resolve('missing.js') }
        .to raise_error(PrecompiledAssets::Resolver::UnknownAsset, /Could not find "missing.js"/)
    end

    describe 'auto-reload behavior' do
      context 'in the development environment' do
        before do
          allow(Rails.env).to receive(:development?).and_return(true)
        end

        it 'reloads the manifest when it has changed on disk' do
          original_manifest = resolver.manifest
          resolver.resolve('application.js')

          new_manifest = AssetFixtures.write_manifest('application.js' => 'application-NEW.js')
          AssetFixtures.bump_mtime(new_manifest)

          expect(resolver.resolve('application.js')).to eq('/assets-test/application-NEW.js')
          expect(resolver.manifest).not_to equal(original_manifest)
        end
      end

      context 'in other environments' do
        it 'does not reload the manifest when it has changed on disk' do
          original_manifest = resolver.manifest
          resolver.resolve('application.js')

          new_manifest = AssetFixtures.write_manifest('application.js' => 'application-NEW.js')
          AssetFixtures.bump_mtime(new_manifest)

          expect(resolver.resolve('application.js')).to eq('/assets-test/application-HP2LS2UH.js')
          expect(resolver.manifest).to equal(original_manifest)
        end
      end
    end
  end

  describe '#manifest' do
    it 'memoizes the manifest instance' do
      expect(resolver.manifest).to be_a(PrecompiledAssets::Manifest)
      expect(resolver.manifest).to equal(resolver.manifest)
    end
  end

  describe '#reload_manifest' do
    it 'returns a fresh manifest instance' do
      first = resolver.manifest
      expect(resolver.reload_manifest).not_to equal(first)
    end
  end
end
