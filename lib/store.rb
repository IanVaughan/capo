require 'redis'

class Store
  class << self
    def get_count(key)
      redis.get(save_key(key)).to_i
    end

    def inc_count(key)
      redis.incr(save_key(key))
    end

    def save(key, data)
      redis.rpush(save_key(key), data)
    end

    def update(key, index, data)
      redis.lset(save_key(key), index, data)
    end

    def delete(key, index)
      redis.lset save_key(key), index, "foo"
      redis.lrem save_key(key), 1, "foo"
    end

    def range(key, x, y)
      redis.lrange(save_key(key), x, y)
    end

    def read(key, index)
      res = redis.lindex(save_key(key), index)
      return if res.nil?
      JSON.parse res
    end

    private

    def redis
      @redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end

    def save_key(key)
      "capo:#{key}"
    end

    def uri
      URI.parse(url)
    end

    def url
      ENV["REDIS_URL"] || 'redis://localhost:6379'
    end
  end
end
