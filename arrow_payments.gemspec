require File.expand_path("../lib/arrow_payments/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "arrow_payments"
  s.version     = ArrowPayments::VERSION
  s.summary     = "Ruby wrapper for ArrowPayments gateway"
  s.description = "Ruby wrapper for ArrowPayments gateway"
  s.homepage    = "http://github.com/sosedoff/arrow_payments"
  s.authors     = ["Dan Sosedoff"]
  s.email       = ["dan.sosedoff@gmail.com"]

  s.add_development_dependency "webmock",   "~> 1.6.0"
  s.add_development_dependency "rake",      "~> 11.0"
  s.add_development_dependency "rspec",     "~> 3.4"
  s.add_development_dependency "simplecov", "~> 0.7"
  s.add_development_dependency "pry"

  s.add_dependency "faraday",            "~> 0.9.2"
  s.add_dependency "faraday_middleware", "~> 0.10.0"
  s.add_dependency "hashie",             "~> 2.0"
  s.add_dependency "json",               "~> 1.8"

  s.files = Dir["lib/*.rb"] + Dir["lib/arrow_payments/*.rb"]
  s.files += Dir["[A-Z]*"] + Dir["spec/**/*"]

  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 2.3.1"
end
