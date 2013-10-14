WingedCouch::Tools::Base.preload_models
WingedCouch::Tools::DatabaseCreator.create_missing_databases(Rails.logger)

WingedCouch::ViewsLoader.filepath = ENV["COUCH_VIEWS"] || Rails.root.join("config", "winged_couch", "views.js")

WingedCouch::Tools::ViewsUploader.upload_custom_views(Rails.logger)
WingedCouch::Tools::ViewsUploader.upload_default_views(Rails.logger)

Rails.logger.flush