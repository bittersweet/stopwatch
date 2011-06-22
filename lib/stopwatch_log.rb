class StopwatchLog
  @@query_count = 0

  cattr_accessor :event

  def self.query_count
    @@query_count
  end

  def self.reset_query_count
    @@query_count = 0
  end

  def self.increment_query_count
    @@query_count += 1
  end
end
