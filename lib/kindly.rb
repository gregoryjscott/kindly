require 'kindly/queue'
require 'kindly/db'
require 'kindly/runner'
require 'kindly/requester'
require 'kindly/registry'
require 'kindly/jobs/do_nothing'
require 'kindly/jobs/test_job'
require 'kindly/version'
require 'aws-sdk'

module Kindly

  def self.run(job_name)
    Runner.new.run(job_name)
  end

  def self.request(job_name, input = {})
    Requester.new.request(job_name, input)
  end

end
