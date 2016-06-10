require 'simplecov'
SimpleCov.start do
  add_filter ".bundle"
end

require 'webmock'
require 'webmock/rspec'
require 'json'
require 'lib/arrow_payments'

def fixture_path(filename=nil)
  path = File.expand_path("../fixtures", __FILE__)
  filename.nil? ? path : File.join(path, filename)
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end

def json_fixture(file)
  JSON.parse(fixture(file))
end

def api_url(path=nil)
  ["http://demo.arrowpayments.com/api", path].join
end

def stub_api(method, path, options={})
  options[:status]  ||= 200
  options[:headers] ||= {}
  options[:body]    ||= ""

  stub_request(method, api_url(path)).to_return(options)
end
