class StopwatchLog
  @@query_count = 0
  @@sub_query_count = 0
  @@events = []

  cattr_accessor :event
  cattr_accessor :events

  def self.query_count
    @@query_count
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
