require 'kindly'
require 'aws-sdk'
require 'time'
require 'securerandom'

module Kindly
  class DB

    DEFAULTS = {
      :table_names => {
        :ping => 'user-ping',
        :data => 'job-data',
        :pending => 'job-pending',
        :running => 'job-running',
        :completed => 'job-completed',
        :failed => 'job-failed'
      }
    }

    def initialize(options = {})
      @config = DEFAULTS.merge(options)
      @db = Aws::DynamoDB::Client.new(region: 'us-west-2')
    end

    def user
      @user ||= Aws::IAM::CurrentUser.new(region: 'us-west-2')
    end

    def ping
      item = {
        'PingId' => SecureRandom.uuid,
        'PingBy' => user.user_name,
        'PingAt' => Time.now.utc.iso8601
      }

      @db.put_item({ table_name: @config[:table_names][:ping], item: item })
      item
    end

    def insert_job(job_name, input)
      item = {
        'JobId' => SecureRandom.uuid,
        'JobName' => job_name,
        'RequestedAt' => Time.now.utc.iso8601,
        'RequestedBy' => user.user_name
      }

      unless input.empty?
        data = insert_job_data(input)
        item['InputDataId'] = data['JobDataId']
      end

      @db.put_item({ table_name: 'job-pending', item: item })
      item
    end

    def insert_job_data(data)
      item = {
        'JobDataId' => SecureRandom.uuid,
        'Data' => data,
        'CreatedAt' => Time.now.utc.iso8601
      }
      @db.put_item({ table_name: 'job-data', item: item })
      item
    end

    def fetch_job(job_name, job_id)
      job = Registry.find(job_name)
      fields = fetch_job_fields(job_id)
      add_fields_to_job(job, fields)

      if job.fields.has_key?('InputDataId')
        input = fetch_job_data(job.fields['InputDataId'])
        job.input = input
      elsif job.fields.has_key?('Input')
        job.input = job.fields['Input']
      end
      job
    end

    def update_job_status(job, job_status)
      case job_status
      when :running
        delete_job_status(job, :pending)
      when :completed, :failed
        delete_job_status(job, :running)
      else
        raise "#{new_status} is invalid for job #{job.fields['JobId']}."
      end
      insert_job_status(job, job_status)
    end

    private

    def fetch_job_fields(job_id)
      response = @db.query({
        table_name: @config[:table_names][:pending],
        select: 'ALL_ATTRIBUTES',
        key_condition_expression: "JobId = :job_id",
        expression_attribute_values: { ":job_id": job_id }
      })

      raise no_jobs(job_id) if response.items.length == 0
      raise too_many_jobs(job_id) if response.items.length > 1
      response.items[0]
    end

    def fetch_job_data(job_data_id)
      response = @db.query({
        table_name: @config[:table_names][:data],
        select: 'ALL_ATTRIBUTES',
        key_condition_expression: "JobDataId = :job_data_id",
        expression_attribute_values: { ":job_data_id": job_data_id }
      })

      raise no_job_data(job_data_id) if response.items.length == 0
      raise too_many_job_data(job_data_id) if response.items.length > 1
      response.items[0]['Data']
    end

    def add_fields_to_job(job, fields)
      job.instance_eval do
        def fields
          @fields
        end

        def fields=(val)
          @fields = val
        end
      end
      job.fields = fields
    end

    def insert_job_status(job, job_status)
      job.fields['CreatedAt'] = Time.now.utc.iso8601
      @db.put_item({
        table_name: @config[:table_names][job_status],
        item: job.fields
      })
    end

    def delete_job_status(job, job_status)
      @db.delete_item({
        table_name: @config[:table_names][job_status],
        key: { 'JobId': job.fields['JobId'] }
      })
    end

    def no_jobs(job_id)
      "No pending jobs found for #{job_id}."
    end

    def too_many_jobs(job_id)
      "Found too many pending job records for #{job_id}."
    end

    def no_job_data(job_data_id)
      "No job data found for #{job_data_id}."
    end

    def too_many_job_data(job_data_id)
      "Found too many job data records for #{job_data_id}."
    end

  end
end
