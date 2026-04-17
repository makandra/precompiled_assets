require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'gemika/tasks'

RSpec::Core::RakeTask.new(:spec)

if Gem.loaded_specs.include?('rubocop')
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end


task default: 'matrix:spec'
