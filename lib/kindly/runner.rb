require 'kindly'

module Kindly
  class Runner

    def initialize(db, handler)
      @db = db
      @handler = handler
    end

    def run(migration)
      begin
        output = capture_output do
          migration.running!
          @handler.run(migration.job)
        end
        migration.completed!(output)
      rescue Exception
        puts $!, $@
        migration.failed!(output)
      end

      # write_log_file(migration, output)
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
