# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{attaboy}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Marc Lainez}]
  s.date = %q{2011-06-01}
  s.description = %q{Gives recommandations about the constraints that should be set on the database schema}
  s.email = %q{ml@theotherguys.be}
  s.extra_rdoc_files = [%q{README.rdoc}, %q{lib/attaboy.rb}, %q{lib/constraints_processor.rb}, %q{lib/data_factory.rb}, %q{lib/query_builder.rb}]
  s.files = [%q{Gemfile}, %q{Gemfile.lock}, %q{Manifest}, %q{README.rdoc}, %q{Rakefile}, %q{attaboy.gemspec}, %q{lib/attaboy.rb}, %q{lib/constraints_processor.rb}, %q{lib/data_factory.rb}, %q{lib/query_builder.rb}, %q{test/attaboy_spec.rb}, %q{test/constraints_processor_spec.rb}, %q{test/data_factory_spec.rb}, %q{test/features/presence_validator.feature}, %q{test/features/step_definitions/attaboy_steps.rb}, %q{test/fixtures/migrations/attaboy_spec_migrations.rb}, %q{test/fixtures/models/some_model.rb}, %q{test/query_builder_spec.rb}, %q{test/spec_helper.rb}]
  s.homepage = %q{http://github.com/mlainez/attaboy}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Attaboy}, %q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{attaboy}
  s.rubygems_version = %q{1.8.4}
  s.summary = %q{Gives recommandations about the constraints that should be set on the database schema}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
