$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require_relative "lib/pay/asaas/version"

Gem::Specification.new do |spec|
  spec.name = "pay-asaas"
  spec.version = Pay::Asaas::VERSION
  spec.authors = ["PedroAugustoRamalhoDuarte"]
  spec.email = ["pedroaugustorduarte@gmail.com"]

  spec.summary = "Asaas payment processor for pay gem (Payments engine for Ruby on Rails)."
  spec.homepage = "https://github.com/PedroAugustoRamalhoDuarte/pay-asaas"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/PedroAugustoRamalhoDuarte/pay-asaas"
  spec.metadata["changelog_uri"] = "https://github.com/PedroAugustoRamalhoDuarte/pay-asaas"
  spec.metadata["github_repo"] = "https://github.com/PedroAugustoRamalhoDuarte/pay-asaas"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(["git", "ls-files", "-z"], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?("bin/", "test/", "spec/", "features/", ".git", ".github", "appveyor", "Gemfile")
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "httparty"
  spec.add_dependency "pay", "~> 8"
end
