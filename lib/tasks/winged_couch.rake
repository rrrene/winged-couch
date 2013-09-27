namespace :winged_couch do
  namespace :db do
    desc "Creates databases for defined models"
    task :create => :environment do
      dir = ENV["COUCH_MODELS_DIR"] || Rails.root.join("app", "models")
      dir = dir.to_s.strip

      if Dir.exists?(dir)
        pattern = File.join(dir, "**", "*.rb")
        Dir[pattern].each { |f| require f }

        WingedCouch::Model.subclasses.each do |klass|
          if klass.database.exist?
            puts "Database for model #{klass.name} aleady exist"
          else
            klass.database.create
            puts "Created database for model #{klass.name}"
          end
        end
      else
        raise "Directory \"#{dir}=\" doesn't exist!"
      end
    end
  end 
end