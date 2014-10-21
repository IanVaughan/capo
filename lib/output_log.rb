module Capo
  class OutputLog
    REDIS_KEY = 'log'

    def initialize
      @count = Store.save(REDIS_KEY, self)
      @log = []
    end

    def puts(text)
      @log << text
      Store.update(REDIS_KEY, @count - 1, @log.to_json)
    end

    class << self
      def read(log_number)
        Store.read(REDIS_KEY, log_number)
      end
    end
  end
end
