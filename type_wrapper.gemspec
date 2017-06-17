# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "type_wrapper/version"

Gem::Specification.new do |spec|
  spec.name          = "type_wrapper"
  spec.version       = TypeWrapper::VERSION
  spec.authors       = ["Ritchie Paul Buitre"]
  spec.email         = ["ritchie@richorelse.com"]

  spec.summary       = "Another Delegator"
  spec.homepage      = "https://github.com/RichOrElse/type-wrapper/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
