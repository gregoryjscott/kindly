require 'kindly'
require 'minitest/autorun'
require 'mocha/mini_test'

describe 'Migration' do

  let(:filename) { File.join('test', 'fixtures', 'pending', 'one.json') }
  let(:migration) { migration = Kindly::Migration.new(filename) }

  before(:each) do
    Kindly.stubs(:source).returns(File.join('test', 'fixtures'))
  end

  describe 'should log' do

    before(:each) { migration.stubs(:move) }

    it 'when loading' do
      output = capture_output { migration.load }
      assert loading?(output)
    end

    it 'when running' do
      output = capture_output { migration.running! }
      assert running?(output)
    end

    it 'when completed' do
      output = capture_output { migration.completed! }
      assert completed?(output)
    end

    it 'when failed' do
      output = capture_output { migration.failed! }
      assert failed?(output)
    end

    def loading?(output)
      output.include?("#{filename} loading")
    end

    def running?(output)
      output.include?("#{filename} running")
    end

    def completed?(output)
      output.include?("#{filename} completed") && !failed?(output)
    end

    def failed?(output)
      output.include?("#{filename} failed") && !completed?(output)
    end

  end

  describe 'should move files' do

    let(:source) { File.join('test', 'fixtures') }
    let(:tmp_dir) { File.join(source, 'tmp') }

    before(:each) do
      FileUtils.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
      Dir[File.join(source, 'pending', '*.json')].each do |file|
        FileUtils.cp(file, tmp_dir)
      end
    end

    after(:each) do
      restore_pending
      remove(File.join(source, 'running'))
      remove(File.join(source, 'completed'))
      remove(File.join(source, 'failed'))
      remove(tmp_dir)
    end

    it 'when running' do
      capture_output { migration.running! }
      assert File.exist?(File.join(source, 'running', File.basename(filename)))
    end

    it 'when completed' do
      capture_output { migration.completed! }
      assert File.exist?(File.join(source, 'completed', File.basename(filename)))
    end

    it 'when failed' do
      capture_output { migration.failed! }
      assert File.exist?(File.join(source, 'failed', File.basename(filename)))
    end

    def restore_pending
      pending_dir = File.join(source, 'pending')
      FileUtils.rm_r(pending_dir)
      FileUtils.mkdir(pending_dir)
      Dir[File.join(tmp_dir, '*.json')].each do |file|
        FileUtils.cp(file, pending_dir)
      end
    end

    def remove(dir)
      FileUtils.rm_r(dir) if Dir.exist?(dir)
    end

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
