# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'allpay/version'

Gem::Specification.new do |spec|
  spec.name          = 'allpay_client'
  spec.version       = Allpay::VERSION
  spec.authors       = ['Jian Weihang']
  spec.email         = ['tonytonyjan@gmail.com']
  spec.summary       = '歐付寶（Allpay）API 包裝'
  spec.description   = '歐付寶（Allpay）API 包裝'
  spec.homepage      = 'https://github.com/tonytonyjan/allpay'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sinatra'
end
