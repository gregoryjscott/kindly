require 'kindly'
require 'minitest/autorun'

describe 'Kindly::Handlers' do

  let(:handlers) { Kindly::Handlers }
  let(:default_handler) { Kindly::Handlers::Default.new }

  it 'throws if handler is not registered' do
    assert_raises(RuntimeError) { handlers.find(:missing_handler) }
  end

  it 'allows handlers to be registered' do
    handlers.register :default, default_handler
    assert handlers.find(:default) == default_handler
  end

  it 'allows handlers to be unregistered' do
    handlers.register :default, default_handler
    handlers.unregister :default
    assert_raises(RuntimeError) { handlers.find(:default) }
  end

end
