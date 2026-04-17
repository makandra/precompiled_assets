require 'stringio'

module SpecHelpers

  def silence_stdout
    original = $stdout
    $stdout = StringIO.new
    yield
  ensure
    $stdout = original
  end

end

RSpec.configure do |config|
  config.include SpecHelpers
end
