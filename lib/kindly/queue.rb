require 'kindly'
require 'aws-sdk'

module Kindly
  class Queue

    def initialize(handler_name)
      @handler_name = handler_name
      @sqs = Aws::SQS::Client.new(region: 'us-west-2')
      queue = handler_name.to_s.gsub('_', '-')
      @queue_url = "https://sqs.us-west-2.amazonaws.com/529271381487/#{queue}"
    end

    def pop
      response = @sqs.receive_message({
        queue_url: @queue_url,
        message_attribute_names: ['JobId'],
        max_number_of_messages: 1
      })
      raise too_many_messages if response.messages.length > 1
      return [nil, nil] if response.messages.length == 0
      message = response.messages[0]
      [message.message_attributes['JobId'].string_value, message]
    end

    def delete(message)
      @sqs.delete_message({
        queue_url: @queue_url,
        receipt_handle: message.receipt_handle
      })
    end

    private

    def too_many_messages
      "Found too many messages for #{@handler_name}."
    end

  end
end
