require 'load_speed'
require 'stopwatch_log'
require 'stopwatch_event'

module Stopwatch
  class Railtie < Rails::Railtie
    initializer "newplugin.initialize" do |app|
      app.config.middleware.use "Rack::LoadSpeed"

      ActiveSupport::Notifications.subscribe "start_processing.action_controller" do |*args|
        StopwatchLog.reset_query_count
        StopwatchLog.reset_events
      end

      ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
        StopwatchLog.event = ActiveSupport::Notifications::Event.new(*args)
      end

      ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
        StopwatchLog.increment_query_count if payload[:name] != "CACHE"
        StopwatchLog.increment_sub_query_count if payload[:name] != "CACHE"
      end

      ActiveSupport::Notifications.subscribe "render_partial.action_view" do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        stopwatch_event = StopwatchEvent.new(event)
        stopwatch_event.query_count = StopwatchLog.sub_query_count
        StopwatchLog.events << stopwatch_event
        StopwatchLog.reset_sub_query_count
      end
    end
  end
end
