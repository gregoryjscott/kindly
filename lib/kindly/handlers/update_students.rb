require 'kindly'

module Kindly
  module Handlers
    class UpdateStudents

      def run(job)
        puts "The handler for job: #{job['JobId']} ran."
      end

    end

    register(:update_students, UpdateStudents.new)
  end
end
