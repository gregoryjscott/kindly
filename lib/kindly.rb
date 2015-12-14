require 'kindly/migration'
require 'kindly/runner'
require 'kindly/handlers'
require 'kindly/handlers/do_nothing'
require 'kindly/version'
require 'aws-sdk'

module Kindly

  DEFAULTS = {
    :pending => 'job-pending',
    :running => 'job-running',
    :completed => 'job-completed',
    :failed => 'job-failed'
  }

  def self.run(handler_name, options = {})
    @@config = DEFAULTS.merge(options)
    # puts "Kindly run #{handler_name} in #{@@config[:source]} directory."

    @@db = Aws::DynamoDB::Client.new(region: 'us-west-2')
    @@sqs = Aws::SQS::Client.new(region: 'us-west-2')

    # handler = Handlers.find(handler_name)
    # runner = Runner.new(handler)
    migrations = find_migrations(handler_name)

    # puts "No migrations found for #{handler_name} handler." if migrations.empty?
    # migrations.each { |migration| runner.run(migration) }
  end

  def self.config
    @@config
  end

  private

  def self.find_migrations(handler_name)
    queue = handler_name.to_s.gsub('_', '-')
    queue_url = "https://sqs.us-west-2.amazonaws.com/529271381487/#{queue}"
    sqs_resp = @@sqs.receive_message({
      queue_url: queue_url,
      message_attribute_names: ['JobId'],
      max_number_of_messages: 1
    })

    if sqs_resp.messages.length == 1
      job_id = sqs_resp.messages[0].message_attributes['JobId'].string_value
      db_resp = @@db.scan({
        table_name: config[:pending],
        select: 'ALL_ATTRIBUTES',
        filter_expression: "JobId = :job_id",
        expression_attribute_values: { ":job_id": job_id }
      })
      puts "Found #{db_resp.items.length} db records for JobId:#{job_id}."
      if db_resp.items.length > 0
        db_resp.items.each do |item|
          @@db.delete_item({
            table_name: config[:pending],
            key: { 'JobId': item['JobId'] }
          })
        end
        puts "Deleted db records for JobId:#{job_id}"

        @@sqs.delete_message({
          queue_url: queue_url,
          receipt_handle: sqs_resp.messages[0].receipt_handle
        })
        puts "Deleted message #{sqs_resp.messages[0].receipt_handle}"
      end
    end
  end

  def self.build_migrations(filenames)
    migrations = []
    filenames.each { |filename| migrations << Migration.new(filename) }
    migrations
  end

end
