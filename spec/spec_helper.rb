if ENV["TRAVIS"]
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'winged_couch'
require 'pry'

GEM_ROOT = File.expand_path("../../", __FILE__)

Dir[File.join(GEM_ROOT, "spec", "support", "**/*.rb")].each { |f| require f }

WingedCouch.logger = nil # Logger.new(STDOUT)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include Helpers::FlushDBs,     :flush_dbs
  config.include Helpers::WithDatabase, :with_database
end


def upload_views(klass)
  WingedCouch::ViewsLoader.filepath = File.join(GEM_ROOT, "spec", "support", "views.js")
  WingedCouch::ViewsLoader.upload_views_for(klass)
end