require 'kindly'

module Kindly
  module Handlers
    class Default

      def ext
        '.*'
      end

      def run(migration)
        puts "No migration handlers for #{migration.filename} were found."
      end

    end

    register :do_nothing, Default.new
  end
end
