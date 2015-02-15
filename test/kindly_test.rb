require 'kindly'
require 'minitest/autorun'
require 'mocha/mini_test'

describe 'Kindly' do

  it 'runs given handler name' do
    Kindly.stubs(:source).returns(File.join('test', 'fixtures'))
    Kindly::Runner.any_instance.expects(:run).twice
    capture_output { Kindly.run(:do_nothing) }
  end

  it 'defaults source to _migrations' do
    Kindly::Runner.any_instance.stubs(:run)
    capture_output { Kindly.run(:do_nothing) }
    assert Kindly.source == '_migrations'
  end

  it 'allows source to be overridden' do
    Kindly::Runner.any_instance.stubs(:run)
    fixtures = File.join('test', 'fixtures')
    capture_output { Kindly.run(:do_nothing, fixtures) }
    assert Kindly.source == fixtures
  end

  def capture_output
    begin
      old_stdout = $stdout
      $stdout = StringIO.new('', 'w')
      yield
      $stdout.string
    ensure
      $stdout = old_stdout
    end
  end

end
