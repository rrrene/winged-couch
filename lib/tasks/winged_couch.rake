namespace :winged_couch do

  def tool
    WingedCouch::Tools::Base
  end

  namespace :db do
    desc "Creates databases for defined models"
    task :create => :environment do
      tool.preload_models
      WingedCouch::Tools::DatabaseCreator.create_missing_databases
    end
  end

  namespace :views do
    task :prepare => :environment do
      tool.preload_models
      WingedCouch::ViewsLoader.filepath = ENV["COUCH_VIEWS"] || Rails.root.join("config", "winged_couch", "views.js")
    end

    namespace :custom do
      desc "Uploads custom design views to the database"
      task :upload => :prepare do
        WingedCouch::Tools::ViewsUploader.upload_custom_views
      end
    end

    namespace :default do
      desc "Uploads default design views to the database"
      task :upload => :prepare do
        WingedCouch::Tools::ViewsUploader.upload_default_views
      end
    end
  end 
end