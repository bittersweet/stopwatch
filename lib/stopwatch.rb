require 'load_speed'
require 'stopwatch_log'
require 'stopwatch_event'

module Stopwatch
  class Railtie < Rails::Railtie
    initializer "newplugin.initialize" do |app|
      app.config.middleware.use "Rack::LoadSpeed"

      # Start processing
      ActiveSupport::Notifications.subscribe "start_processing.action_controller" do |*args|
        StopwatchLog.reset_query_count
        StopwatchLog.reset_sub_query_count
        StopwatchLog.reset_events
      end

      # Every query
      ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
        if payload[:name] != "CACHE"
          StopwatchLog.increment_query_count
          StopwatchLog.increment_sub_query_count
        end
      end

      # Every partial render
      ActiveSupport::Notifications.subscribe(/render/) do |name, start, finish, id, payload|
        event = ActiveSupport::Notifications::Event.new(name, start, finish, id, payload)
        stopwatch_event = StopwatchEvent.new(event)
        stopwatch_event.query_count = StopwatchLog.sub_query_count
        StopwatchLog.events << stopwatch_event
        StopwatchLog.reset_sub_query_count
      end

      # End of processing
      ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
        StopwatchLog.event = ActiveSupport::Notifications::Event.new(*args)
      end
    end
  end
end
