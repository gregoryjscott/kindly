require 'kindly'

module Kindly
  class Requester

    def request(handler_name, input = {})
      db = Aws::DynamoDB::Client.new(region: 'us-west-2')
      job_id = SecureRandom.uuid
      job_data_id = SecureRandom.uuid
      timestamp = Time.now.to_s

      db.put_item({
        table_name: 'job-data',
        item: {
          'JobDataId' => job_data_id,
          'Data' => { hello: 'world' },
          'Created' => timestamp
        }
      })

      db.put_item({
        table_name: 'job-pending',
        item: {
          'JobId' => job_id,
          'JobDataId' => job_data_id,
          'Created' => timestamp
        }
      })

      queue = Queue.new(handler_name)
      queue.insert(job_id)
    end

  end
end
