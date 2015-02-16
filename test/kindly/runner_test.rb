require 'kindly'
require 'minitest/autorun'
require 'mocha/mini_test'
require 'fileutils'

describe 'Runner' do

  let(:filename) { File.join('test', 'fixtures', 'pending', 'one.json') }
  let(:migration) { migration = Kindly::Migration.new(filename) }
  let(:runner) { Kindly::Runner.new(Kindly::Handlers::DoNothing.new) }

  before(:each) do
    migration.stubs(:move)
  end

  after(:each) do
    logfile = "#{filename}.log"
    FileUtils.rm(logfile) if File.exist?(logfile)
  end

  it 'sets migration to running if loads succeeds' do
    migration.expects(:running!).once
    runner.run(migration)
  end

  it 'sets migration to loading even if load fails' do
    migration.stubs(:load).raises
    migration.expects(:running!).once
    runner.run(migration)
  end

  it 'sets migration to completed if Runner succeeds' do
    migration.expects(:completed!).once
    migration.expects(:failed!).never
    runner.run(migration)
  end

  it 'writes log file' do
    runner.run(migration)
    expected_log_file = "#{migration.filename}.log"
    assert File.exist?(expected_log_file)
  end

end
