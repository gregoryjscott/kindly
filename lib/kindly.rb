require 'kindly/db'
require 'kindly/queue'
require 'kindly/registry'
require 'kindly/requester'
require 'kindly/runner'
require 'kindly/version'
require 'kindly/jobs/do_nothing'
require 'kindly/jobs/test_job'
require 'kindly/jobs/test_job_with_input'
require 'kindly/jobs/test_job_with_output'
require 'aws-sdk'

module Kindly

  def self.run(job_name)
    Runner.new.run(job_name)
  end

  def self.request(job_name, input = {})
    Requester.new.request(job_name, input)
  end

  def self.ping
    DB.new.ping
  end

end
