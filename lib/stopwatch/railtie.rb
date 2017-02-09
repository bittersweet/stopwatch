module Stopwatch
  class Railtie < Rails::Railtie
    initializer "newplugin.initialize" do |app|
      app.config.middleware.use "Rack::LoadSpeed"

      # Start processing
      ActiveSupport::Notifications.subscribe "start_processing.action_controller" do |*args|
        Stopwatch::Log.reset_query_count
        Stopwatch::Log.reset_sub_query_count
        Stopwatch::Log.reset_events
      end

      # Every query
      ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
        if payload[:name] != "CACHE"
          Stopwatch::Log.increment_query_count
          Stopwatch::Log.increment_sub_query_count
        end
      end

      # Every partial render
      ActiveSupport::Notifications.subscribe(/render/) do |name, start, finish, id, payload|
        event = ActiveSupport::Notifications::Event.new(name, start, finish, id, payload)
        stopwatch_event = Stopwatch::Event.new(event)
        stopwatch_event.query_count = Stopwatch::Log.sub_query_count
        Stopwatch::Log.events << stopwatch_event
        Stopwatch::Log.reset_sub_query_count
      end

      # End of processing
      ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
        Stopwatch::Log.event = ActiveSupport::Notifications::Event.new(*args)
      end
    end
  end
end
