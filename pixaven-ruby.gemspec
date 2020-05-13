# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "optidash"

Gem::Specification.new do |spec|
    spec.name = "optidash"
    spec.version = Optidash::VERSION
    spec.summary = "Official Ruby integration for Optidash API"
    spec.description = "Optidash: AI-powered image optimization and processing API. We will drastically speed-up your websites and save you money on bandwidth and storage."
    spec.author = ["Optidash UG"]
    spec.email = ["support@optidash.com"]
    spec.homepage = "https://optidash.ai"
    spec.license = "MIT"

    spec.files = `git ls-files -z`.split("\x0")
    spec.require_paths = ['lib']

    spec.add_development_dependency 'bundler', '~> 2.0'
    spec.add_development_dependency 'rake', '~> 10.0'

    spec.add_dependency 'json', '~> 2.0.3'
    spec.add_dependency 'rest-client', '~> 2.0.1'
end