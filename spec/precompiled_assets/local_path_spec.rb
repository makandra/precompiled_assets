describe PrecompiledAssets::LocalPath do
  around do |example|
    original = Rails.configuration.asset_path
    Rails.configuration.asset_path = asset_path
    example.run
  ensure
    Rails.configuration.asset_path = original
  end

  describe '.pathname' do
    context 'when asset_path has a leading slash' do
      let(:asset_path) { '/assets-test' }

      it 'joins Rails.public_path with the configured asset_path' do
        expect(described_class.pathname.to_s).to eq(Rails.public_path.join('assets-test').to_s)
      end
    end

    context 'when asset_path has no leading slash' do
      let(:asset_path) { 'assets-test' }

      it 'still produces the same pathname' do
        expect(described_class.pathname.to_s).to eq(Rails.public_path.join('assets-test').to_s)
      end
    end
  end
end
