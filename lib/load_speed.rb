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
      html = <<-EOF
<style>
  #performance_code {
    position: absolute;
    top: 0;
    right: 0;
    height: 25px;
    background-color: #DE7A93;
    color: white;
    padding: 0 10px 0 10px;
    line-height: 20pt;
    font-family: "menlo";
    font-size: 10pt;
    text-align: right;
  }
</style>
<div id="performance_code">
  <strong>#{StopwatchLog.event.duration.to_i}</strong> ms
  <strong>#{StopwatchLog.query_count}</strong> queries
</div>
EOF
      html
    end
  end
end
