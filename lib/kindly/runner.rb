require 'kindly'

module Kindly
  class Runner

    def initialize(handler_name)
      @handler = Handlers.find(handler_name)
    end

    def run(job)
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
