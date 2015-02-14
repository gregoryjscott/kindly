require 'kindly'

module Kindly
  module Handlers

    def self.register(name, handler)
      @@handlers ||= {}
      @@handlers[name.to_sym] = handler
    end

    def self.unregister(name)
      @@handlers.delete(name.to_sym)
    end

    def self.find(name)
      if handler_not_registered(name)
        raise "No handler registered with name #{name.to_sym}."
      end

      @@handlers[name.to_sym]
    end

    private

    def self.handler_not_registered(name)
      !@@handlers.has_key?(name)
    end
  end
end
