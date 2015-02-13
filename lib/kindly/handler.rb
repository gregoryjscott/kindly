require 'kindly'

module Kindly
  class Handler

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
