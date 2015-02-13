require 'kindly/migration'
require 'kindly/handler'
require 'kindly/version'

module Kindly

  def self.handler
    @handler ||= Handler.new
  end

  def self.run
    migrations = Migration.find_pending
    unless migrations.empty?
      migrations.each { |migration| handler.run(migration) }
    end
  end

end
