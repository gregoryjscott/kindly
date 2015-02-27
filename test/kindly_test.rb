require 'kindly'
require 'minitest/autorun'
require 'mocha/mini_test'

describe 'Kindly' do
  let(:fixtures) { File.join('test', 'fixtures') }
  let(:pending) { File.join(fixtures, 'pending') }

  it 'runs given handler name' do
    Kindly.stubs(:config).returns(:source => fixtures)
    Kindly::Runner.any_instance.expects(:run).twice
    capture_output { Kindly.run(:do_nothing) }
  end

  it 'defaults source to _migrations' do
    Kindly::Runner.any_instance.stubs(:run)
    capture_output { Kindly.run(:do_nothing) }
    assert Kindly.config[:source] == '_migrations'
  end

  it 'allows source to be overridden' do
    Kindly::Runner.any_instance.stubs(:run)
    capture_output { Kindly.run(:do_nothing, :source => fixtures) }
    assert Kindly.config[:source] == fixtures
  end

  it 'defaults pending to _migrations/pending' do
    expected = File.join('_migrations', 'pending')
    Kindly::Runner.any_instance.stubs(:run)
    capture_output { Kindly.run(:do_nothing) }
    assert Kindly.config[:pending] == expected
  end

  it 'allows pending to be overridden' do
    Kindly::Runner.any_instance.stubs(:run)
    capture_output { Kindly.run(:do_nothing, :pending => pending) }
    assert_equal pending, Kindly.config[:pending]
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
