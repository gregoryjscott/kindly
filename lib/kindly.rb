require 'kindly/migration'
require 'kindly/runner'
require 'kindly/handlers'
require 'kindly/handlers/do_nothing'
require 'kindly/version'

module Kindly

  DEFAULTS = {
    :source => '_migrations'
  }

  def self.run(handler_name, options = DEFAULTS)
    options = DEFAULTS.merge(options)
    @@config = options
    puts "Kindly run #{handler_name} in #{@@config[:source]} directory."

    handler = Handlers.find(handler_name)
    runner = Runner.new(handler)
    migrations = find_migrations(handler.ext)

    puts "No migrations found for #{handler_name} handler." if migrations.empty?
    migrations.each { |migration| runner.run(migration) }
  end

  def self.config
    @@config
  end

  private

  def self.find_migrations(ext)
    filenames = Dir[File.join(config[:source], 'pending', "*.#{ext}")]
    build_migrations(filenames)
  end

  def self.build_migrations(filenames)
    migrations = []
    filenames.each { |filename| migrations << Migration.new(filename) }
    migrations
  end

end
