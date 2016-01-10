require 'kindly'

module Kindly
  module Jobs
    class TestJob

      def run
        puts "fields: #{@fields}"
      end

    end

    Kindly::Registry.register(:test_job, TestJob.new)
  end
end
