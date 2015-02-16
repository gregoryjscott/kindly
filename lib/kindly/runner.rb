require 'kindly'

module Kindly
  class Runner

    def initialize(handler)
      @handler = handler
    end

    def run(migration)
      output = capture_output do
        begin
          migration.running!
          @handler.run(migration)
          migration.completed!
        rescue Exception
          puts $!, $@
          migration.failed!
        end
      end

      write_log_file(migration, output)
    end

    private

    def capture_output
      begin
        old_stdout = $stdout
        $stdout = StringIO.new('', 'w')
        yield
        $stdout.string
      ensure
        $stdout = old_stdout
      end
    end

    def write_log_file(migration, output)
      filename = "#{migration.filename}.log"
      File.open(filename, 'w') { |file| file.write(output) }
    end

  end
end
