require 'kindly'
require 'minitest/autorun'
require 'mocha/mini_test'
require 'fixtures/jobs/fail'


describe 'Kindly::Runner' do

  # let(:job) { mock() }
  #
  # before(:each) do
  #   job.stubs(:fetch)
  #   job.stubs(:data)
  #   job.stubs(:running!)
  # end

  # it 'returns if the job is a success' do
  #   job.stubs(:completed!)
  #   result = Kindly::Runner.new(:do_nothing).run(job)
  #   assert result[:success]
  # end
  #
  # it 'returns if the job is not a success' do
  #   job.stubs(:failed!)
  #   result = Kindly::Runner.new(:fail).run(job)
  #   refute result[:success]
  # end

end

# require 'kindly'
# require 'minitest/autorun'
# require 'mocha/mini_test'
# require 'fileutils'
# require 'fixtures/handlers/fail'
#
# describe 'Runner' do
#
#   let(:read_json) { File.join('test', 'fixtures', 'jobs', 'read_json') }
#   let(:filename) { File.join(read_json, 'pending', 'one.json') }
#   let(:job) { job = Kindly::Job.new(filename) }
#   let(:runner) { Kindly::Runner.new(Kindly::Handlers::DoNothing.new) }
#   let(:runner_that_fails) { Kindly::Runner.new(Fixtures::Handlers::Fail.new) }
#
#   before(:each) do
#     job.stubs(:move)
#   end
#
#   after(:each) do
#     logfile = "#{filename}.log"
#     FileUtils.rm(logfile) if File.exist?(logfile)
#   end
#
#   it 'sets job to running' do
#     job.expects(:running!).once
#     runner.run(job)
#   end
#
#   it 'sets job to completed if job succeeds' do
#     job.expects(:completed!).once
#     job.expects(:failed!).never
#     runner.run(job)
#   end
#
#   it 'sets job to failed if job fails' do
#     job.expects(:completed!).never
#     job.expects(:failed!).once
#     runner_that_fails.run(job)
#   end
#
#   it 'writes log file' do
#     runner.run(job)
#     expected_log_file = "#{job.filename}.log"
#     assert File.exist?(expected_log_file)
#   end
#
# end
