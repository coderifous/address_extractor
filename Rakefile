require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('address_extractor', '0.1.2') do |p|
  p.description    = "Give it text.  It finds addresses in it."
  p.url            = "http://github.com/coderifous/address_extractor"
  p.author         = "Jim Garvin"
  p.email          = "jim at thegarvin dot com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
