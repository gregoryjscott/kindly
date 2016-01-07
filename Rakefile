require 'bundler/gem_tasks'
require 'rake/testtask'
require 'kindly'

Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc 'Try update_students'
task :update_student do
  Kindly.run :update_student
end

task :default => :test
