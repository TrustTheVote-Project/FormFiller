require_relative 'lib/formfiller/version'

Gem::Specification.new do |spec|
  spec.name          = "formfiller"
  spec.version       = FormFiller::VERSION
  spec.authors       = ["Cliff Wulfman"]
  spec.email         = ["cwulfman@gmail.com"]

  spec.summary       = "Fill out and sign fillable PDFs using iText."
  spec.description   = "Inspired by fillable-pdf."
  spec.homepage      = "https://github.com/cwulfman/FormFiller"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.5")

#  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

#spec.metadata["homepage_uri"] = https://github.com/cwulfman/FormFiller
#spec.metadata["source_code_uri"] = "https://github.com/cwulfman/FormFiller"
#  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = %w[ext lib]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "pry", "~> 0.12.2"

  spec.add_runtime_dependency 'rjb', '~> 1.6'
end
