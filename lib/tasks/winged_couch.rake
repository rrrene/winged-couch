namespace :winged_couch do
  def models_dir
    @models_dir ||= begin
      dir = ENV["COUCH_MODELS_DIR"] || Rails.root.join("app", "models")
      dir.to_s.strip
    end
  end

  task :preload_models => :environment do
    raise "Directory \"#{models_dir}=\" doesn't exist!" unless Dir.exists?(models_dir)
    pattern = File.join(models_dir, "**", "*.rb")
    Dir[pattern].each { |f| require f }
  end

  namespace :db do
    desc "Creates databases for defined models"
    task :create => :preload_models do
      WingedCouch::Model.subclasses.each do |klass|
        if klass.database.exist?
          puts "Database for model #{klass.name} aleady exist"
        else
          klass.database.create
          puts "Created database for model #{klass.name}"
        end
      end
    end
  end

  namespace :views do
    task :prepare_for_upload => :preload_models do
      WingedCouch::ViewsLoader.filepath = ENV["COUCH_VIEWS"] || Rails.root.join("config", "winged_couch", "views.js")
    end

    desc "Uploads design views to the database"
    task :upload => :prepare_for_upload do
      WingedCouch::Model.subclasses.each do |klass|
        if klass.database.exist?
          begin
            WingedCouch::ViewsLoader.upload_views_for(klass)
            puts "Updated views for klass #{klass.name}"
          rescue WingedCouch::Exceptions::ViewsMissing
            puts "Can't find views for class #{klass.name}"
          end            
        else
          raise "Database for model #{klass.name} doesn't exist, run rake winged_couch:db:create"
        end
      end
    end
  end 
end