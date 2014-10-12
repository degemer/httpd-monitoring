lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require 'httpd_monitoring/version'
Gem::Specification.new do |s|
  s.name = 'httpd_monitoring'
  s.version = HttpdMonitoring::VERSION
  s.description = 'HTTP log monitoring console program'
  s.summary = "httpd-monitoring-#{s.version}"
  s.authors = ['Quentin Madec']
  s.license = 'MIT'
  s.executables << 'httpd-monitoring'
  s.add_dependency('eventmachine')
  s.add_dependency('eventmachine-tail')
  s.files = Dir['lib/**/*.rb']
  s.files += Dir['spec/**/*']
  s.files += Dir['*.md']
  s.required_ruby_version = '>= 1.9.3'
end
