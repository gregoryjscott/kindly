require 'kindly'
require 'fileutils'
require 'json'

module Kindly
  class Migration

    attr_reader :job

    def initialize(config, db, job_id)
      @config = config
      @db = db
      @job = find_job(job_id)
    end

    def running!
      @db.delete_item({
        table_name: @config[:pending],
        key: { 'JobId': @job['JobId'] }
      })
      @db.put_item({
        table_name: @config[:running],
        item: {
          'JobId' => @job['JobId'],
          'JobDataId' => @job['JobDataId'],
          'Created' => Time.now.to_s,
        }
      })
      puts "Job: #{@job['JobId']} running."
    end

    def completed!(output)
      @db.delete_item({
        table_name: @config[:running],
        key: { 'JobId': @job['JobId'] }
      })
      @db.put_item({
        table_name: @config[:completed],
        item: {
          'JobId' => @job['JobId'],
          'JobDataId' => @job['JobDataId'],
          'Log' => output,
          'Created' => Time.now.to_s,
        }
      })
      puts "Job: #{@job['JobId']} completed."
    end

    def failed!(output)
      @db.delete_item({
        table_name: @config[:running],
        key: { 'JobId': @job['JobId'] }
      })
      @db.put_item({
        table_name: @config[:failed],
        item: {
          'JobId' => @job['JobId'],
          'JobDataId' => @job['JobDataId'],
          'Log' => output,
          'Created' => Time.now.to_s,
        }
      })
      puts "Job: #{@job['JobId']} failed."
    end

    private

    def find_job(job_id)
      response = @db.scan({
        table_name: @config[:pending],
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

    def no_jobs(job_id)
      "No pending jobs found for #{@job_id}."
    end

    def too_many_jobs(job_id)
      "Found to many pending jobs for #{@job_id}."
    end

  end
end
