# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transformable_list/version'

Gem::Specification.new do |spec|
  spec.name          = "transformable_list"
  spec.version       = TransformableList::VERSION
  spec.authors       = ["Maxim Chernyak"]
  spec.email         = ["max@crossfield.com"]

  spec.summary       = %q{Determine steps to transform a list into another list}
  spec.description   = %q{Given 2 lists this gem would show steps necessary } +
                       %q{to convert one to another.}
  spec.homepage      = "https://github.com/crossfield/transformable_list"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
