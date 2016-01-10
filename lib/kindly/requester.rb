require 'kindly'

module Kindly
  class Requester

    def initialize
      @queue = Queue.new
      @db = DB.new
    end

    def request(job_name, input = {})
      job = @db.insert_job(job_name, input)
      @queue.add(job_name, job['JobId'])
    end

  end
end
