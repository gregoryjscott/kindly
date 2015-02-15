require 'kindly'
require 'minitest/autorun'
require 'mocha/mini_test'

describe 'Runner' do

  let(:filename) { File.join('test', 'fixtures', 'pending', 'one.json') }
  let(:migration) { migration = Kindly::Migration.new(filename) }
  let(:runner) { Kindly::Runner.new(Kindly::Handlers::DoNothing.new) }

  before(:each) do
    migration.stubs(:move)
  end

  it 'sets migration to running if loads succeeds' do
    migration.expects(:running!).once
    capture_output { runner.run(migration) }
  end

  it 'sets migration to loading even if load fails' do
    migration.stubs(:load).raises
    migration.expects(:running!).once
    capture_output { runner.run(migration) }
  end

  it 'sets migration to completed if Runner succeeds' do
    migration.expects(:completed!).once
    migration.expects(:failed!).never
    capture_output { runner.run(migration) }
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
