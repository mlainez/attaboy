require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('attaboy', '0.0.0') do |p|
  p.description    = "Gives recommandations about the constraints that should be set on the database schema"
  p.url            = "http://github.com/mlainez/attaboy"
  p.author         = "Marc Lainez"
  p.email          = "ml@theotherguys.be"
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }