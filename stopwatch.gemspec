# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "stopwatch/version"

Gem::Specification.new do |s|
  s.name        = "stopwatch"
  s.version     = Stopwatch::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Mulder"]
  s.email       = ["markmulder@gmail.com"]
  s.homepage    = "http://ikbenbitterzoet.com"
  s.summary     = "Show the page load duration."
  s.description = "This gem uses Rack middleware and the Rails 3 instrumentation to display page load time."

  s.rubyforge_project = "stopwatch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
