
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fcfinder/version'

Gem::Specification.new do |spec|
  spec.name          = 'fcfinder'
  spec.version       = Fcfinder::VERSION
  spec.authors       = ["DanielES"]
  spec.email         = ["danielelizondo12@gmail.com"]

  spec.summary       = %q{ Web file explorer for Rails. }
  spec.description   = %q{ You can use the file explorer to create folders such as cke tinymce you can quickly get integrated with the editor you will use the file explorer.}
  spec.homepage      = 'https://github.com/es-daniel/fcfinder_es'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'mini_magick', '~> 4.9.2'
  spec.add_dependency 'rubyzip', '~> 1.1'
end
