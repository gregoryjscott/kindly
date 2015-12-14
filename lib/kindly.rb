require 'kindly/job'
require 'kindly/runner'
require 'kindly/handlers'
require 'kindly/handlers/do_nothing'
require 'kindly/handlers/update_students'
require 'kindly/version'
require 'aws-sdk'

module Kindly

  DEFAULTS = {
    :data => 'job-data',
    :pending => 'job-pending',
    :running => 'job-running',
    :completed => 'job-completed',
    :failed => 'job-failed'
  }

  def self.run(handler_name, options = {})
    config = DEFAULTS.merge(options)
    sqs = Aws::SQS::Client.new(region: 'us-west-2')
    queue = handler_name.to_s.gsub('_', '-')
    queue_url = "https://sqs.us-west-2.amazonaws.com/529271381487/#{queue}"

    message = receive_message(sqs, queue_url, handler_name)
    if message.nil?
      puts "No messages found for #{handler_name}."
    else
      db = Aws::DynamoDB::Client.new(region: 'us-west-2')
      job_id = message.message_attributes['JobId'].string_value
      job = Job.new(config, db, job_id)
      handler = Handlers.find(handler_name)
      Runner.new(db, handler).run(job)
      delete_message(sqs, queue_url, message)
    end
  end

  private

  def self.receive_message(sqs, queue_url, handler_name)
    response = sqs.receive_message({
      queue_url: queue_url,
      message_attribute_names: ['JobId'],
      max_number_of_messages: 1
    })
    raise too_many_messages(handler_name) if response.messages.length > 1
    response.messages[0]
  end

  def self.delete_message(sqs, queue_url, message)
    sqs.delete_message({
      queue_url: queue_url,
      receipt_handle: message.receipt_handle
    })
  end

  def self.too_many_messages(handler_name)
    "Found too many messages for #{handler_name}."
  end

end
