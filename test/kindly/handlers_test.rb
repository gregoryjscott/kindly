require 'kindly'
require 'minitest/autorun'

describe 'Kindly::Handlers' do

  let(:handlers) { Kindly::Handlers }
  let(:handler) { Kindly::Handlers::Default.new }

  it 'throws if handler is not registered' do
    assert_raises(RuntimeError) { handlers.find(:missing) }
  end

  it 'allows handlers to be registered' do
    handlers.register :different, handler
    assert handlers.find(:different) == handler
  end

  it 'allows handlers to be unregistered' do
    handlers.register :different, handler
    handlers.unregister :different
    assert_raises(RuntimeError) { handlers.find(:different) }
  end

end
