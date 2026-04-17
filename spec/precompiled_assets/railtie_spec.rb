describe PrecompiledAssets::Railtie do
  describe 'ActionView integration' do
    it 'includes PrecompiledAssets::Helper in ActionView::Base' do
      expect(ActionView::Base.include?(PrecompiledAssets::Helper)).to be true
    end
  end

  describe 'ViewComponent integration', if: defined?(ViewComponent::Base) do
    it 'includes PrecompiledAssets::Helper in ViewComponent::Base' do
      expect(ViewComponent::Base.include?(PrecompiledAssets::Helper)).to be true
    end
  end

  describe 'rake tasks' do
    it 'registers assets:precompile' do
      expect(Rake::Task.task_defined?('assets:precompile')).to be true
    end

    it 'registers assets:clobber' do
      expect(Rake::Task.task_defined?('assets:clobber')).to be true
    end

    it 'registers assets:clean' do
      expect(Rake::Task.task_defined?('assets:clean')).to be true
    end

    it 'assets:clobber invokes Tasks.remove_all' do
      expect(PrecompiledAssets::Tasks).to receive(:remove_all)
      Rake::Task['assets:clobber'].execute
    end

    it 'assets:clean invokes Tasks.remove_unused' do
      expect(PrecompiledAssets::Tasks).to receive(:remove_unused)
      Rake::Task['assets:clean'].execute
    end
  end
end
