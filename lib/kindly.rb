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
    @@config = DEFAULTS.merge(options)
    default_sub_dir_if_missing(:pending)
    default_sub_dir_if_missing(:running)
    default_sub_dir_if_missing(:completed)
    default_sub_dir_if_missing(:failed)
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

  def self.default_sub_dir_if_missing(sym)
    config[sym] = default(sym.to_s) unless config.has_key?(sym)
  end

  def self.default(sub_dir)
    File.join(config[:source], sub_dir)
  end

  def self.find_migrations(ext)
    filenames = Dir[File.join(config[:pending], "*.#{ext}")]
    build_migrations(filenames)
  end

  def self.build_migrations(filenames)
    migrations = []
    filenames.each { |filename| migrations << Migration.new(filename) }
    migrations
  end

end
