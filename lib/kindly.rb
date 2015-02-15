require 'kindly/migration'
require 'kindly/runner'
require 'kindly/handlers'
require 'kindly/handlers/default'
require 'kindly/version'

module Kindly

  def self.run(handler_name, source = '_migrations')
    @@source = source
    puts "Kindly run #{handler_name} in #{source} directory."

    handler = Handlers.find(handler_name)
    runner = Runner.new(handler)
    migrations = find_migrations(handler.ext)

    puts "No migrations found for #{handler_name} handler." if migrations.empty?
    migrations.each { |migration| runner.run(migration) }
  end

  def self.source
    @@source
  end

  private

  def self.find_migrations(ext)
    filenames = Dir[File.join(source, 'pending', "*.#{ext}")]
    build_migrations(filenames)
  end

  def self.build_migrations(filenames)
    migrations = []
    filenames.each { |filename| migrations << Migration.new(filename) }
    migrations
  end

end
