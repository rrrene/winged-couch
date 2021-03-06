# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'winged_couch/version'

Gem::Specification.new do |spec|
  spec.name          = "winged_couch"
  spec.version       = WingedCouch::VERSION
  spec.authors       = ["Ilya Bylich"]
  spec.email         = ["ibylich@gmail.com"]
  spec.description   = %q{ORM for CouchDB}
  spec.summary       = %q{ORM for CouchDB}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "redcarpet"
  spec.add_dependency "rest-client"
  spec.add_dependency "therubyracer"
  spec.add_dependency "activesupport"
end
