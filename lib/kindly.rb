require 'require_all'
require_all 'lib'

module Kindly

  def self.run(job_name)
    Runner.new.run(job_name)
  end

  def self.request(job_name, input = {})
    Requester.new.request(job_name, input)
  end

end
