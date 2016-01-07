require 'kindly'
require 'fileutils'
require 'json'

module Kindly
  class Job

    attr_reader :data

    def initialize(config, job_id)
      @config = config
      @id = job_id
      @db = Aws::DynamoDB::Client.new(region: 'us-west-2')
    end

    def fetch
      @fields = fetch_pending_fields
      @data = fetch_job_data
    end

    def running!
      delete(:pending)
      insert(:running)
      puts "Job: #{@id} running."
    end

    def completed!(log)
      delete(:running)
      @fields['Log'] = log
      insert(:completed)
      puts "Job: #{@id} completed."
    end

    def failed!(log)
      delete(:running)
      @fields['Log'] = log
      insert(:failed)
      puts "Job: #{@id} failed."
    end

    private

    def fetch_pending_fields
      response = @db.scan({
        table_name: @config[:table_names][:pending],
        select: 'ALL_ATTRIBUTES',
        filter_expression: "JobId = :job_id",
        expression_attribute_values: { ":job_id": @id }
      })

      if response.items.length == 0
        raise no_jobs
      elsif response.items.length > 1
        raise too_many_jobs
      end

      response.items[0]
    end

    def fetch_job_data
      response = @db.scan({
        table_name: @config[:table_names][:data],
        select: 'ALL_ATTRIBUTES',
        filter_expression: "JobDataId = :job_data_id",
        expression_attribute_values: { ":job_data_id": @fields['JobDataId'] }
      })

      if response.items.length == 0
        raise no_job_data
      elsif response.items.length > 1
        raise too_many_job_data
      end

      response.items[0]
    end

    def insert(table_name)
      @fields['Created'] = Time.now.to_s
      @db.put_item({
        table_name: @config[:table_names][table_name],
        item: @fields
      })
    end

    def delete(table_name)
      @db.delete_item({
        table_name: @config[:table_names][table_name],
        key: { 'JobId': @id }
      })
    end

    def no_jobs
      "No pending jobs found for #{@id}."
    end

    def no_job_data
      "No job data found for #{@id}."
    end

    def too_many_jobs
      "Found too many pending job records for #{@id}."
    end

    def too_many_job_data
      "Found too many job data records for #{@id}."
    end

  end
end
