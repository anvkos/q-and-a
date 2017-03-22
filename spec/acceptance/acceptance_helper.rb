require 'rails_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit

  Capybara.server = :puma

  config.include AcceptanceMacros, type: :feature
  config.include SphinxHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
