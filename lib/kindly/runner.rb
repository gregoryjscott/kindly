require 'kindly'

module Kindly
  class Runner

    DEFAULTS = {
      :table_names => {
        :data => 'job-data',
        :pending => 'job-pending',
        :running => 'job-running',
        :completed => 'job-completed',
        :failed => 'job-failed'
      }
    }

    def initialize
      @queue = Queue.new
      @db = DB.new
    end

    def run(job_name)
      job_id = @queue.peek(job_name)
      if job_id.nil?
        puts "No pending requests for #{job_name}."
        return false
      end

      job = @db.fetch_job(job_name, job_id)
      run_job(job)
      @queue.remove(job_name, job_id)
      job.respond_to?(:output) ? job.output : {}
    end

    private

    def run_job(job)
      failed = false
      log = capture_stdout do
        job.fields['StartedAt'] = Time.now.to_s
        @db.update_job_status(job, :running)
        begin
          job.run
        rescue
          failed = true
          puts $!, $@
        end
      end

      job.fields['StoppedAt'] = Time.now.to_s
      job.fields['Log'] = log
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
