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
    config = DEFAULTS.merge(options)
    queue = Kindly::Queue.new(handler_name)

    message = queue.receive_message
    if message.nil?
      puts "No messages found for #{handler_name}."
    else
      db = Aws::DynamoDB::Client.new(region: 'us-west-2')
      job_id = message.message_attributes['JobId'].string_value
      job = Job.new(config, db, job_id)
      handler = Handlers.find(handler_name)
      Runner.new(handler).run(job)
      queue.delete_message(message)
    end
  end

end
