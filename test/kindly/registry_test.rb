require 'kindly'
require 'minitest/autorun'

describe 'Kindly::Registry' do

  let(:registry) { Kindly::Registry }
  let(:do_nothing) { Kindly::Jobs::DoNothing.new }

  it 'throws if job is not registered' do
    assert_raises(RuntimeError) { registry.find(:missing) }
  end

  it 'allows job to be registered' do
    registry.register :do_nothing, do_nothing
    assert registry.find(:do_nothing) == do_nothing
  end

  it 'allows job to be unregistered' do
    registry.register :do_nothing, do_nothing
    registry.unregister :do_nothing
    assert_raises(RuntimeError) { registry.find(:do_nothing) }
  end

end
