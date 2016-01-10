require 'kindly'
require 'minitest/autorun'
# require 'mocha/mini_test'

describe 'Kindly' do

  # it 'works' do
  #   Kindly.request :test_job
  # end

  # it 'returns true if message was handled' do
  #   Kindly::Runner.any_instance.stubs(:run)
  #   Kindly::Queue.any_instance.stubs(:pop).returns([1, { hello: 'world' }])
  #   Kindly::Queue.any_instance.stubs(:delete)
  #   assert Kindly.run(:do_nothing)
  # end
  #
  # it 'returns false if message was not found' do
  #   Kindly::Runner.any_instance.stubs(:run)
  #   Kindly::Queue.any_instance.stubs(:pop).returns([nil, nil])
  #   Kindly::Queue.any_instance.stubs(:delete)
  #   capture_output { refute Kindly.run(:do_nothing) }
  # end

  # let(:read_json) { File.join('test', 'fixtures', 'jobs', 'read_json') }
  # let(:pending) { File.join(read_json, 'pending') }
  #
  # it 'runs given handler name' do
  #   Kindly.stubs(:config).returns(:source => read_json)
  #   Kindly::Runner.any_instance.expects(:run).twice
  #   capture_output { Kindly.run(:do_nothing) }
  # end
  #
  # it 'defaults source to _jobs' do
  #   Kindly::Runner.any_instance.stubs(:run)
  #   capture_output { Kindly.run(:do_nothing) }
  #   assert Kindly.config[:source] == '_jobs'
  # end
  #
  # it 'allows source to be overridden' do
  #   Kindly::Runner.any_instance.stubs(:run)
  #   capture_output { Kindly.run(:do_nothing, :source => read_json) }
  #   assert Kindly.config[:source] == read_json
  # end
  #
  # it 'defaults pending to _jobs/pending' do
  #   expected = File.join('_jobs', 'pending')
  #   Kindly::Runner.any_instance.stubs(:run)
  #   capture_output { Kindly.run(:do_nothing) }
  #   assert Kindly.config[:pending] == expected
  # end
  #
  # it 'allows pending to be overridden' do
  #   Kindly::Runner.any_instance.stubs(:run)
  #   capture_output { Kindly.run(:do_nothing, :pending => pending) }
  #   assert_equal pending, Kindly.config[:pending]
  # end

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
