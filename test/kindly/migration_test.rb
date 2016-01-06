# require 'kindly'
# require 'minitest/autorun'
# require 'mocha/mini_test'
#
# describe 'Job' do
#   let(:source) { File.join('test', 'fixtures', 'jobs', 'read_json') }
#   let(:config) {
#     {
#       :source => source,
#       :pending => File.join(source, 'pending'),
#       :running => File.join(source, 'running'),
#       :completed => File.join(source, 'completed'),
#       :failed => File.join(source, 'failed')
#     }
#   }
#   let(:filename) { File.join(config[:pending], 'one.json') }
#   let(:job) { job = Kindly::Job.new(filename) }
#
#   before(:each) do
#     Kindly.stubs(:config).returns(config)
#   end
#
#   describe 'logs' do
#     before(:each) { job.stubs(:move) }
#
#     it 'when running' do
#       output = capture_output { job.running! }
#       assert running?(output)
#     end
#
#     it 'when completed' do
#       output = capture_output { job.completed! }
#       assert completed?(output)
#     end
#
#     it 'when failed' do
#       output = capture_output { job.failed! }
#       assert failed?(output)
#     end
#
#     def running?(output)
#       output.include?("#{filename} running")
#     end
#
#     def completed?(output)
#       output.include?("#{filename} completed") && !failed?(output)
#     end
#
#     def failed?(output)
#       output.include?("#{filename} failed") && !completed?(output)
#     end
#
#   end
#
#   describe 'moves files' do
#
#     let(:tmp_dir) { File.join(source, 'tmp') }
#
#     before(:each) do
#       FileUtils.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
#       Dir[File.join(source, 'pending', '*.json')].each do |file|
#         FileUtils.cp(file, tmp_dir)
#       end
#     end
#
#     after(:each) do
#       restore_pending
#       remove(config[:running])
#       remove(config[:completed])
#       remove(config[:failed])
#       remove(tmp_dir)
#     end
#
#     it 'when running' do
#       capture_output { job.running! }
#       assert File.exist?(File.join(config[:running], File.basename(filename)))
#     end
#
#     it 'when completed' do
#       capture_output { job.completed! }
#       assert File.exist?(File.join(config[:completed], File.basename(filename)))
#     end
#
#     it 'when failed' do
#       capture_output { job.failed! }
#       assert File.exist?(File.join(config[:failed], File.basename(filename)))
#     end
#
#     def restore_pending
#       FileUtils.rm_r(config[:pending])
#       FileUtils.mkdir(config[:pending])
#       Dir[File.join(tmp_dir, '*.json')].each do |file|
#         FileUtils.cp(file, config[:pending])
#       end
#     end
#
#     def remove(dir)
#       FileUtils.rm_r(dir) if Dir.exist?(dir)
#     end
#
#   end
#
#   def capture_output
#     begin
#       old_stdout = $stdout
#       $stdout = StringIO.new('', 'w')
#       yield
#       $stdout.string
#     ensure
#       $stdout = old_stdout
#     end
#   end
#
# end
