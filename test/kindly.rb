require 'kindly'
require 'minitest/autorun'
require 'mocha/mini_test'

describe 'Kindly' do

  before(:each) do
    Kindly::Migration.stubs(:source).returns(File.join('test', 'fixtures'))
  end

  it 'runs all migrations even if one fails' do
    handler = Kindly::Handler.new
    handler.expects(:run).times(2)
    Kindly.stubs(:handler).returns(handler)
    Kindly.run
  end

end
