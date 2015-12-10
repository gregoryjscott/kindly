require 'kindly'

module Kindly
  module Handlers
    class DoNothing

      def glob
        '*'
      end

      def run(migration)
        puts "The handler for #{migration.filename} did nothing."
      end

    end

    register(:do_nothing, DoNothing.new)
  end
end
