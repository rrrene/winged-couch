# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'couch_orm/version'

Gem::Specification.new do |spec|
  spec.name          = "couch_orm"
  spec.version       = CouchORM::VERSION
  spec.authors       = ["Ilya Bylich"]
  spec.email         = ["ilya.bylich@productmadness.com"]
  spec.description   = %q{ORM for CouchDB}
  spec.summary       = %q{ORM for CouchDB}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
