require 'kindly'
require 'minitest/autorun'
require 'mocha/mini_test'
require 'fileutils'
require 'fixtures/handlers/fail'

describe 'Runner' do

  let(:read_json) { File.join('test', 'fixtures', 'jobs', 'read_json') }
  let(:filename) { File.join(read_json, 'pending', 'one.json') }
  let(:migration) { migration = Kindly::Migration.new(filename) }
  let(:runner) { Kindly::Runner.new(Kindly::Handlers::DoNothing.new) }
  let(:runner_that_fails) { Kindly::Runner.new(Fixtures::Handlers::Fail.new) }

  before(:each) do
    migration.stubs(:move)
  end

  after(:each) do
    logfile = "#{filename}.log"
    FileUtils.rm(logfile) if File.exist?(logfile)
  end

  it 'sets migration to running' do
    migration.expects(:running!).once
    runner.run(migration)
  end

  it 'sets migration to completed if migration succeeds' do
    migration.expects(:completed!).once
    migration.expects(:failed!).never
    runner.run(migration)
  end

  it 'sets migration to failed if migration fails' do
    migration.expects(:completed!).never
    migration.expects(:failed!).once
    runner_that_fails.run(migration)
  end

  it 'writes log file' do
    runner.run(migration)
    expected_log_file = "#{migration.filename}.log"
    assert File.exist?(expected_log_file)
  end

end
