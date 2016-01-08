require 'kindly/job'
require 'kindly/queue'
require 'kindly/runner'
require 'kindly/handlers'
require 'kindly/handlers/do_nothing'
require 'kindly/handlers/update_student'
require 'kindly/version'
require 'aws-sdk'

module Kindly

  DEFAULTS = {
    :table_names => {
      :data => 'job-data',
      :pending => 'job-pending',
      :running => 'job-running',
      :completed => 'job-completed',
      :failed => 'job-failed'
    }
  }

  def self.run(handler_name, options = {})
    queue = Kindly::Queue.new(handler_name)
    job_id, message = queue.pop
    if job_id.nil? || message.nil?
      puts "No messages found for #{handler_name}."
      false
    else
      config = DEFAULTS.merge(options)
      job = Job.new(config, job_id)
      Runner.new(handler_name).run(job)
      queue.delete(message)
      true
    end
  end

end
