# encoding: utf-8
#
require_relative './../lib/stopwatch'
require_relative './../lib/load_speed'

require 'rack/lint'
require "rack/mock"

describe Rack::LoadSpeed do
  # Copied from https://github.com/rails/rails/blob/3e48bfd49730331d8f09d4d96bb9a58959017a9c/activesupport/lib/active_support/notifications/instrumenter.rb#L78
  # so we don't have to depend on AS
  class Event
    attr_reader :name, :time, :transaction_id, :payload, :children
    attr_accessor :end

    def initialize(name, start, ending, transaction_id, payload)
      @name           = name
      @payload        = payload.dup
      @time           = start
      @transaction_id = transaction_id
      @end            = ending
      @children       = []
      @duration       = nil
    end

    def duration
      @duration ||= 1000.0 * (self.end - time)
    end
  end

  it 'inserts performance data' do
    app = lambda { |env| [200, {'Content-Type' => 'text/html'}, ["<html><body>test</body></html>"]]}
    event = Event.new('test', 1, 2, '123', { identifier: "app/views/tests/index.html.erb" })
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
    event = Event.new('test', 1, 2, '123', {})
    response = Rack::LoadSpeed.new(app).call({})

    body = response[2][0]
    expect(body).to eq "{'id': '1'}"
  end

  it 'check content-length via Rack::Lint' do
    app = lambda { |env| [200, {'Content-Type' => 'text/html'}, ["<html><body>snowman ☃</body></html>"]]}
    loadspeed = Rack::LoadSpeed.new(app)
    request = Rack::MockRequest.new(Rack::Lint.new(loadspeed))
    response = request.get('/')
    expect(response.status).to eq 200
  end
end
