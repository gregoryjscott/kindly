require 'kindly'
require 'fileutils'
require 'json'

module Kindly
  class Job

    attr_reader :data

    def initialize(config, db, job_id)
      @config = config
      @db = db
      @job = fetch_job(job_id)
      @data = fetch_job_data(@job)
    end

    def running!
      @db.delete_item({
        table_name: @config[:table_names][:pending],
        key: { 'JobId': @job['JobId'] }
      })
      @db.put_item({
        table_name: @config[:table_names][:running],
        item: {
          'JobId' => @job['JobId'],
          'JobDataId' => @job['JobDataId'],
          'Created' => Time.now.to_s,
        }
      })
      puts "Job: #{@job['JobId']} running."
    end

    def completed!(log, output)
      @db.delete_item({
        table_name: @config[:table_names][:running],
        key: { 'JobId': @job['JobId'] }
      })
      @db.put_item({
        table_name: @config[:table_names][:completed],
        item: {
          'JobId' => @job['JobId'],
          'JobDataId' => @job['JobDataId'],
          'Output' => output,
          'Log' => log,
          'Created' => Time.now.to_s,
        }
      })
      puts "Job: #{@job['JobId']} completed."
    end

    def failed!(log)
      @db.delete_item({
        table_name: @config[:table_names][:running],
        key: { 'JobId': @job['JobId'] }
      })
      @db.put_item({
        table_name: @config[:table_names][:failed],
        item: {
          'JobId' => @job['JobId'],
          'JobDataId' => @job['JobDataId'],
          'Log' => log,
          'Created' => Time.now.to_s,
        }
      })
      puts "Job: #{@job['JobId']} failed."
    end

    private

    def fetch_job(job_id)
      response = @db.scan({
        table_name: @config[:table_names][:pending],
        select: 'ALL_ATTRIBUTES',
        filter_expression: "JobId = :job_id",
        expression_attribute_values: { ":job_id": job_id }
      })

      if response.items.length == 0
        puts no_jobs
        completed!
        return
      elsif response.items.length > 1
        raise too_many_jobs
      end

      response.items[0]
    end

    def fetch_job_data(job)
      response = @db.scan({
        table_name: @config[:table_names][:data],
        select: 'ALL_ATTRIBUTES',
        filter_expression: "JobDataId = :job_data_id",
        expression_attribute_values: { ":job_data_id": job['JobDataId'] }
      })

      if response.items.length == 0
        puts no_job_data
        completed!
        return
      elsif response.items.length > 1
        raise too_many_job_data
      end

      response.items[0]
    end

    def no_jobs(job_id)
      "No pending jobs found for #{@job_id}."
    end

    def no_job_data(job_id)
      "No job data found for #{@job_id}."
    end

    def too_many_jobs(job_id)
      "Found too many pending job records for #{@job_id}."
    end

    def too_many_job_data(job_id)
      "Found too many job data records for #{@job_id}."
    end

  end
end
