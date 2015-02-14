require 'kindly/migration'
require 'kindly/runner'
require 'kindly/version'

module Kindly

  def self.source
    'migrations'
  end

  def self.find_migrations
    migrations = []
    filenames =  Dir[File.join(source, 'pending', '*.json')]
    filenames.each do |filename|
      migrations << Migration.new(filename)
    end
    migrations
  end

  def self.runner
    @runner ||= runner.new
  end

  def self.run
    migrations = find_migrations
    unless migrations.empty?
      migrations.each { |migration| runner.run(migration) }
    end
  end

end
