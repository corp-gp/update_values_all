# frozen_string_literal: true

require_relative 'lib/update_values_all/version'

Gem::Specification.new do |spec|
  spec.name = 'update_values_all'
  spec.version = UpdateValuesAll::VERSION
  spec.authors = ['Sergei Malykh']
  spec.email = ['xronos.i.am@gmail.com']

  spec.summary = 'The gem allows to update AR-records in batch'
  spec.homepage = 'https://github.com/corp-gp/update_values_all'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/corp-gp/update_values_all'
  spec.metadata['changelog_uri'] = 'https://github.com/corp-gp/update_values_all/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(__dir__) do
      `git ls-files -z`.split("\x0").reject do |f|
        (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
      end
    end
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 4.2'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
