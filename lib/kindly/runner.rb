require 'kindly'

module Kindly
  class Runner

    def initialize(handler)
      @handler = handler
    end

    def run(migration)
      migration.running!
      begin
        @handler.run(migration)

        migration.completed!
      rescue
        migration.failed!
      end
    end

  end
end
