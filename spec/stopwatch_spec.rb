require_relative './../lib/stopwatch'
require_relative './../lib/load_speed'

describe Rack::LoadSpeed do
  it 'inserts performance data' do
    app = lambda { |env| [200, {'Content-Type' => 'text/html'}, ["<html><body>test</body></html>"]]}
    event = ActiveSupport::Notifications::Event.new('test', 1, 2, '123', { identifier: "app/views/tests/index.html.erb" })
    Stopwatch::Log.reset_query_count
    Stopwatch::Log.reset_sub_query_count
    Stopwatch::Log.reset_events

    Stopwatch::Log.events << Stopwatch::Event.new(event)
    Stopwatch::Log.query_count = 12
    Stopwatch::Log.event = event

    response = Rack::LoadSpeed.new(app).call({})

    body = response[2][0]
    expect(body).to include "performance_code"
    expect(body).to include "<strong>1000</strong> ms"
    expect(body).to include "<strong>12</strong> queries"
  end

  it 'does nothing for JS' do
    app = lambda { |env| [200, {'Content-Type' => 'application/json'}, ["{'id': '1'}"] ] }
    event = ActiveSupport::Notifications::Event.new('test', 1, 2, '123', {})
    response = Rack::LoadSpeed.new(app).call({})

    body = response[2][0]
    expect(body).to eq "{'id': '1'}"
  end
end
