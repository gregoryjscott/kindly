require 'kindly'
require 'aws-sdk'

module Kindly
  class Queue

    def initialize
      @sqs = Aws::SQS::Client.new(region: 'us-west-2')
    end

    def add(job_name, job_id)
      @sqs.send_message({
        queue_url: queue_url(job_name),
        message_body: "#{@job_name} has been requested.",
        message_attributes: {
          'JobId' => {
            string_value: job_id,
            data_type: "String",
          },
        },
      })
    end

    def peek(job_name)
      response = @sqs.receive_message({
        queue_url: queue_url(job_name),
        message_attribute_names: ['JobId'],
        max_number_of_messages: 1
      })
      raise too_many_messages(job_name) if response.messages.length > 1
      return nil if response.messages.length == 0

      message = response.messages[0]
      job_id = message.message_attributes['JobId'].string_value
      @messages_in_flight = { job_id => message }
      job_id
    end

    def remove(job_name, job_id)
      message = @messages_in_flight[job_id]
      @sqs.delete_message({
        queue_url: queue_url(job_name),
        receipt_handle: message.receipt_handle
      })
    end

    private

    def queue_url(job_name)
      queue = job_name.to_s.gsub('_', '-')
      "https://sqs.us-west-2.amazonaws.com/529271381487/#{queue}"
    end

    def too_many_messages(job_name)
      "Found too many messages for #{job_name}."
    end

  end
end
