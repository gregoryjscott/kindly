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

desc 'Run test_job'
task :run_test_job do
  Kindly.run :test_job
end

task :default => :test
