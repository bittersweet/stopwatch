module Rack
  class LoadSpeed
    def initialize(app)
      @app = app
    end

    def call(env)
      env.delete("HTTP_IF_NONE_MATCH")
      status, headers, response = @app.call(env)

      if status == 200
        body = ""
        response.each {|part| body << part}
        index = body.rindex("</body>")
        if index
          body.insert(index, performance_code)
          headers["Content-Length"] = body.length.to_s
          response = [body]
        end
      end

      [status, headers, response]
    end

  protected

    def performance_code
      events = "<table><tr><td>view</td><td>duration</td><td>queries</td></tr>"
      StopwatchLog.events.each do |event|
        events << "<tr><td>#{event.template}</td><td>#{event.duration}</td><td>#{event.query_count}</td></tr>"
      end
      events << "</table>"

      html = <<-EOF
<style>
  #performance_code {
    z-index: 1000;
    position: absolute;
    top: 0;
    right: 0;
    height: 25px;
    overflow: hidden;
    background-color: #DE7A93;
    color: white;
    padding: 0 10px 0 10px;
    line-height: 20pt;
    font-family: "menlo";
    font-size: 10pt;
    text-align: right;
  }

  #performance_code:hover {
    height: auto;
    width: auto;
    padding-bottom: 10px;
  }
</style>
<div id="performance_code">
  <strong>#{StopwatchLog.event.duration.to_i}</strong> ms
  <strong>#{StopwatchLog.query_count}</strong> queries
  #{events}
</div>
EOF
      html
    end
  end
end
