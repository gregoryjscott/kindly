require 'kindly'

module Kindly
  class Runner

    def initialize
      @queue = Queue.new
      @db = DB.new
    end

    def run(job_name)
      job_id = @queue.pop(job_name)
      if job_id.nil?
        puts "No pending requests for #{job_name}."
        return false
      end

      job = @db.fetch_job(job_name, job_id)
      run_job(job)

      job.respond_to?(:output) ? job.output : {}
    end

    private

    def run_job(job)
      job.fields['RanBy'] = @db.user.user_name
      job.fields['StartedAt'] = Time.now.to_s
      @db.update_job_status(job, :running)

      failed = false
      log = capture_stdout do
        puts "#{job.fields['JobId']} started at #{job.fields['StartedAt']}."
        begin
          job.run
        rescue
          failed = true
          puts $!, $@
        end
        job.fields['FinishedAt'] = Time.now.to_s
        puts "#{job.fields['JobId']} finished at #{job.fields['FinishedAt']}."

        if job.respond_to? :output
          data = @db.insert_job_data(job.output)
          job.fields['OutputDataId'] = data['JobDataId']
        end
      end
      job.fields['Log'] = log.split("\n")

      if failed
        @db.update_job_status(job, :failed)
      else
        @db.update_job_status(job, :completed)
      end
    end

    private

    def capture_stdout
      begin
        old_stdout = $stdout
        $stdout = StringIO.new('', 'w')
        yield
        $stdout.string
      ensure
        $stdout = old_stdout
      end
    end

  end
end
