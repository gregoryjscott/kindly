require 'kindly'

module Kindly
  class Runner

    def initialize(handler)
      @handler = handler
    end

    def run(job)
      failed = false
      output = nil
      log = capture_stdout do
        job.running!
        begin
          output = @handler.run(job.data)
        rescue
          failed = true
          puts $!, $@
        end
      end

      if failed
        job.failed!(log)
        { success: false }
      else
        job.completed!(log, output)
        { success: true }
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
