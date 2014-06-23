Gem::Specification.new do |spec|
  spec.name          = "lita-ey-base"
  spec.version       = "0.0.1"
  spec.authors       = ["Carlos Paramio"]
  spec.email         = ["cparamio@avallain.com"]
  spec.description   = %q{A Lita base handler with shared code for all ey-lita-* gems.}
  spec.summary       = %q{A Lita base handler with shared code for all ey-lita-* gems.}
  spec.homepage      = "https://github.com/carlosparamio/lita-ey-base"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 3.2.0"

  spec.add_dependency "engineyard"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
end
