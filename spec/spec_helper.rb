require 'simplecov'
SimpleCov.start

require 'couch_orm'
require 'pry'

GEM_ROOT = File.expand_path("../../", __FILE__)

Dir[File.join(GEM_ROOT, "spec", "support", "**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include CouchHelper, :couch
end


def upload_views(klass)
  CouchORM::ViewsLoader.filepath = File.join(GEM_ROOT, "spec", "support", "views.js")
  CouchORM::ViewsLoader.upload_views_for(klass)
end