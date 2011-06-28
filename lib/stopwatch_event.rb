class StopwatchEvent
  attr_accessor :query_count

  def initialize(event)
    @event = event
  end

  def template
    if @event.payload[:virtual_path]
      @event.payload[:virtual_path]
    else
      @event.payload[:identifier].gsub(/.*\/app\/views\//, "")
    end
  end

  def duration
    @event.duration.round(2)
  end
end
