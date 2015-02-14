require 'kindly'
require 'minitest/autorun'
require 'mocha/mini_test'

describe 'Kindly' do

  it 'runs given handler name' do
    Kindly.stubs(:source).returns(File.join('test', 'fixtures'))
    Kindly::Runner.any_instance.expects(:run).twice
    Kindly.run(:default)
  end

end
