Gem::Specification.new do |s|
  s.name = %q{address_extractor}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jim Garvin"]
  s.date = %q{2008-11-21}
  s.description = %q{Give it text.  It finds addresses in it.}
  s.email = %q{jim at thegarvin dot com}
  s.extra_rdoc_files = ["lib/address_extractor.rb", "LICENSE.textile", "README.textile"]
  s.files = ["lib/address_extractor.rb", "LICENSE.textile", "Manifest", "Rakefile", "README.textile", "test/test_address_extractor.rb", "address_extractor.gemspec", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/coderifous/address_extractor}
  s.rdoc_options = ["--line-numbers", "--title", "Address_extractor", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{address_extractor}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Give it text.  It finds addresses in it.}
  s.test_files = ["test/test_address_extractor.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
