require 'kindly/job'
require 'kindly/queue'
require 'kindly/runner'
require 'kindly/requester'
require 'kindly/handlers'
require 'kindly/handlers/do_nothing'
require 'kindly/handlers/update_student'
require 'kindly/version'
require 'aws-sdk'

module Kindly

  def self.run(handler_name)
    Runner.new.run(handler_name)
  end

  def self.request(handler_name, input = {})
    Requester.new.request(handler_name, input)
  end

end
