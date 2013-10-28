# -*- encoding: utf-8 -*-
require File.expand_path('../lib/reittiopas2/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Iivari Äikäs"]
  gem.email         = ["iivari.aikas@gmail.com"]
  gem.description   = %q{Reittiopas version 2 API library.}
  gem.summary       = %q{Gem providing easy access to reittiopas version 2 API.}
  gem.homepage      = "https://github.com/orva/reittiopas2"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "reittiopas2"
  gem.require_paths = ["lib"]
  gem.version       = Reittiopas2::VERSION

  gem.add_dependency "json",        "~> 1.8"
  gem.add_dependency "addressable", "~> 2.3"

  gem.add_development_dependency "rspec",       "~> 2.14"
  gem.add_development_dependency "webmock",     "~> 1.15"
  gem.add_development_dependency "guard-rspec", "~> 4.0"
  gem.add_development_dependency "simplecov",   "~> 0.7"
end
