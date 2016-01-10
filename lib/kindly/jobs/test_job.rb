require 'kindly'

module Kindly
  module Jobs
    class TestJob < Kindly::Job

      def run
        puts "Testing 1, 2, 3."
      end

    end

    Kindly::Registry.register(:test_job, TestJob.new)
  end
end
