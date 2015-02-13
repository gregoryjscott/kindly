require 'kindly/migration'
require 'kindly/handler'
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

  def self.handler
    @handler ||= Handler.new
  end

  def self.run
    migrations = find_migrations
    unless migrations.empty?
      migrations.each { |migration| handler.run(migration) }
    end
  end

end
