require 'bundler/gem_tasks'
require 'rake/testtask'
require 'kindly'

Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc 'Run update_students job'
task :update_student do
  Kindly.run :update_student
end

desc 'Request run_bot job'
task :run_bot do
  Kindly.request :run_bot
end

task :default => :test
