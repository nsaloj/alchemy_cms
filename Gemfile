# frozen_string_literal: true

source "https://rubygems.org"

gemspec

rails_version = ENV.fetch("RAILS_VERSION", "7.1")
gem "rails", "~> #{rails_version}.0"

if ENV["DB"].nil? || ENV["DB"] == "sqlite"
  gem "sqlite3", "~> 1.6.0"
end
if ENV["DB"] == "mysql" || ENV["DB"] == "mariadb"
  gem "mysql2", "~> 0.5.1"
end
gem "pg", "~> 1.0" if ENV["DB"] == "postgresql"

gem "alchemy_i18n", git: "https://github.com/AlchemyCMS/alchemy_i18n.git", branch: "main"

group :development, :test do
  gem "execjs", "~> 2.9.1"
  gem "rubocop", require: false
  gem "standard", "~> 1.25", require: false

  if ENV["GITHUB_ACTIONS"]
    # Necessary because GH Actions gem cache does not have this "Bundled with Ruby" gem installed
    gem "rexml", "~> 3.2.4"
    gem "sassc", "~> 2.4.0" # https://github.com/sass/sassc-ruby/issues/146

    # https://github.com/hotwired/turbo-rails/issues/512
    if rails_version == "7.1"
      gem "actioncable", "~> #{rails_version}.0"
    end
  else
    gem "launchy"
    gem "annotate"
    gem "bumpy"
    gem "yard"
    gem "redcarpet"
    gem "pry-byebug"
    gem "listen"
    gem "localeapp", "~> 3.0", require: false
    gem "dotenv", "~> 2.2"
    gem "github_fast_changelog", require: false
    gem "active_record_query_trace", require: false
    gem "rack-mini-profiler", require: false
    gem "rufo", require: false
    gem "brakeman", require: false
  end
end

# Ruby 3.1 split out the net-smtp gem
# Necessary until https://github.com/mikel/mail/pull/1439
# got merged and released.
if Gem.ruby_version >= Gem::Version.new("3.1.0")
  gem "net-smtp", "~> 0.4.0", require: false
end

gem "web-console", "~> 4.2", group: :development

gem "rails_live_reload", "~> 0.3.5"
