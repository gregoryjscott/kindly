require 'bundler/gem_tasks'
require 'rake/testtask'
require 'kindly'

Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc 'Request test_job'
task :request_test_job do
  Kindly.request :test_job
end

desc 'Request test_job_with_input'
task :request_test_job_with_input do
  Kindly.request :test_job_with_input, 'hello'
end

desc 'Run test_job'
task :run_test_job do
  Kindly.run :test_job
end

desc 'Run test_job_with_input'
task :run_test_job_with_input do
  Kindly.run :test_job_with_input
end

task :default => :test
