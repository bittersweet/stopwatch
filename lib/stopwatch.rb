require 'load_speed'
require 'stopwatch_log'

module Stopwatch
  class Railtie < Rails::Railtie
    initializer "newplugin.initialize" do |app|
      app.config.middleware.use "Rack::LoadSpeed"

      ActiveSupport::Notifications.subscribe "start_processing.action_controller" do |*args|
        StopwatchLog.reset_query_count
      end

      ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
        StopwatchLog.event = ActiveSupport::Notifications::Event.new(*args)
      end

      ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
        StopwatchLog.increment_query_count if payload[:name] != "CACHE"
      end
    end
  end
end
