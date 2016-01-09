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

    def run(handler_name)
      @handler = Handlers.find(handler_name)
      queue = Kindly::Queue.new(handler_name)
      job_id, message = queue.pop
      if job_id.nil? || message.nil?
        puts "No pending requests for #{handler_name} exist."
        false
      else
        config = DEFAULTS.merge(options)
        job = Job.new(config, job_id)
        run_job(job)
        queue.delete(message)
        true
      end
    end

    private

    def run_job(job)
      failed = false
      log = capture_stdout do
        job.fetch
        job.running!
        begin
          @handler.run(job.data)
        rescue
          failed = true
          puts $!, $@
        end
      end

      if failed
        job.failed!(log)
      else
        job.completed!(log)
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
