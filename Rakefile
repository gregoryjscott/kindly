require 'bundler/gem_tasks'
require 'rake/testtask'
require 'kindly'

Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc 'Try update_students'
task :update_students do
  Kindly.run(:update_students)
end

task :default => :test
