require 'kindly'

module Kindly
  class Runner

    def initialize(db, handler)
      @db = db
      @handler = handler
    end

    def run(migration)
      failed = false
      output = capture_output do
        migration.running!
        begin
          @handler.run(migration.job)
        rescue
          failed = true
          puts $!, $@
        end
      end

      if failed
        migration.failed!(output)
      else
        migration.completed!(output)
      end
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

    # def write_log_file(migration, output)
    #   filename = "#{migration.filename}.log"
    #   File.open(filename, 'w') { |file| file.write(output) }
    # end

  end
end
