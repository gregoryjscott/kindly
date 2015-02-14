require 'kindly'

module Kindly
  class Runner

    def run(migration)
      migration.running!
      begin
        # do something

        migration.completed!
      rescue
        migration.failed!
      end
    end

  end
end
