module Stopwatch
  class Log
    @@query_count = 0
    @@sub_query_count = 0
    @@events = []

    def self.event
      @@event
    end
    def self.event=(event)
      @@event = event
    end

    def self.events
      @@events
    end
    def self.events=(events)
      @@events = events
    end

    def self.query_count
      @@query_count
    end
    def self.query_count=(query_count)
      @@query_count = query_count
    end

    def self.sub_query_count
      @@sub_query_count
    end

    def self.reset_query_count
      @@query_count = 0
    end

    def self.reset_sub_query_count
      @@sub_query_count = 0
    end

    def self.increment_query_count
      @@query_count += 1
    end

    def self.increment_sub_query_count
      @@sub_query_count += 1
    end

    def self.reset_events
      @@events = []
    end
  end
end
