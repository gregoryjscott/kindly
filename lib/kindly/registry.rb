require 'kindly'

module Kindly
  module Registry

    def self.register(job_name, job)
      @@jobs ||= {}
      @@jobs[job_name.to_sym] = job
    end

    def self.unregister(job_name)
      @@jobs.delete(job_name.to_sym)
    end

    def self.find(job_name)
      raise no_job(job_name) unless registered?(job_name)
      @@jobs[job_name.to_sym]
    end

    private

    def self.no_job(job_name)
      "No job registered with name #{job_name}."
    end

    def self.registered?(job_name)
      @@jobs.has_key?(job_name.to_sym)
    end
  end
end
