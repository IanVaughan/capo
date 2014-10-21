require 'json'

module Capo
  class Deployment
    attr_reader :build_number, :cmd, :who, :started, :ended, :exit_status

    REDIS_KEY = 'deployment'
    REDIS_COUNT = 'count'

    class << self
      def read(build_number = nil)
        if build_number
          read.keep_if { |d| d.build_number == build_number }.first
        else
          [].tap do |result|
            Store.range(REDIS_KEY, 0, -1).each do |d|
              result << Deployment.from_json(d)
            end
          end
        end
      end

      def delete(build_number)
        Store.delete(REDIS_KEY, find_index(build_number))
      end

      def find_index(build_number)
        index = 0
        read.each_with_index { |b,i| b.build_number == build_number ? index = i : nil }
        index
      end

      def from_json(string)
        d = JSON.load(string)
        return if d.nil?
        self.new(d['build_number'], d['cmd'], d['who'], d['started'], d['ended'], d['exit_status'])
      end
    end

    def initialize(build_number, cmd, who, started, ended = nil, exit_status = nil)
      @build_number = build_number
      @cmd = cmd
      @who = who
      @started = started
      @ended = ended
      @exit_status = exit_status
    end

    def start
      @build_number = Store.get_count(REDIS_COUNT)
      Store.inc_count(REDIS_COUNT)
      @index = Store.save(REDIS_KEY, self.to_json)
    end

    def finished
      @ended = Time.now
      Store.update(REDIS_KEY, @index-1, self.to_json)
    end

    def to_json
      {
        'build_number' => build_number,
        'cmd' => cmd,
        'who' => who,
        'started' => started,
        'ended' => ended,
        'exit_status' => exit_status,
      }.to_json
    end

    def to_s
      [
        ['build_number:', build_number].join,
        ['cmd:', cmd].join,
        ['who:', who].join,
        ['started:', started].join,
        ['ended:', ended].join,
      ].join(', ')
    end
  end
end
