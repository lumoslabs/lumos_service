source 'https://artifactory.ops.aws.lumoslabs.net/artifactory/api/gems/gems'

gem 'activesupport', '~> 5.1.0'

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'rspec'
end

gemspec
