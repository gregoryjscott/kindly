require 'kindly'

module Kindly
  class Runner

    def initialize(db, handler)
      @db = db
      @handler = handler
    end

    def run(migration)
      failed = false
      log = capture_stdout do
        migration.running!
        begin
          @handler.run(migration.data)
        rescue
          failed = true
          puts $!, $@
        end
      end

      if failed
        migration.failed!(log)
      else
        migration.completed!(log)
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
