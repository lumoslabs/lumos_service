lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lumos_service/version"

Gem::Specification.new do |spec|
  spec.name          = "lumos_service"
  spec.version       = LumosService::VERSION
  spec.authors       = ["Andrii Mosin"]
  spec.email         = ["andrii@lumoslabs.com"]

  spec.summary       = 'Service Objects for the win!'
  spec.description   = 'Service Objects for Lumosity'
  spec.homepage      = 'https://github.com/lumoslabs/lumos_service'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
