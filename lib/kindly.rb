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
      puts "No pending requests for #{handler_name} exist."
      false
    else
      config = DEFAULTS.merge(options)
      job = Job.new(config, job_id)
      Runner.new(handler_name).run(job)
      queue.delete(message)
      true
    end
  end

  def self.request(handler_name, input = {})
    db = Aws::DynamoDB::Client.new(region: 'us-west-2')
    job_id = SecureRandom.uuid
    job_data_id = SecureRandom.uuid
    timestamp = Time.now.to_s

    db.put_item({
      table_name: 'job-data',
      item: {
        'JobDataId' => job_data_id,
        'Data' => { hello: 'world' },
        'Created' => timestamp
      }
    })

    db.put_item({
      table_name: 'job-pending',
      item: {
        'JobId' => job_id,
        'JobDataId' => job_data_id,
        'Created' => timestamp
      }
    })

    queue = Kindly::Queue.new(handler_name)
    queue.insert(job_id)
  end

end
