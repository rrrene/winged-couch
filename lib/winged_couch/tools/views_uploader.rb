module WingedCouch
  module Tools

    # Module for uploading default and custom views to the database
    #
    module ViewsUploader

      extend Base

      class << self

        # Uploads custom views specified in file
        #   config/winged_couch/views.js
        #   or in environment variable COUCH_VIEWS
        #
        #
        # @param logger [Logger]
        #
        def upload_custom_views(logger = Logger.new(STDOUT))
          each_model(:raise_exceptions => true) do |model|
            begin
              WingedCouch::ViewsLoader.upload_views_for(model)
              logger.info %Q{Updated views for model "#{model.name}"}
            rescue WingedCouch::Exceptions::ViewsMissing
              logger.error %Q{Can't find views for model "#{model.name}"}
            end
          end
        end

        # Uploads default views (for each attribute)
        #
        # @param logger [Logger]
        #
        def upload_default_views(logger = Logger.new(STDOUT))
          each_model(:raise_exceptions => true) do |model|
            design_document = WingedCouch::Design::Document.from(model.database)

            model.attribute_names.each do |attribute_name|
              WingedCouch::Design::View.create(design_document, *view_attributes(attribute_name))
            end

            logger.info %Q{Uploaded default views for model "#{model.name}"}
          end
        end

        private

        def view_attributes(attribute_name)
          ["by_#{attribute_name}", "map", %Q{function(doc) { emit(doc.#{attribute_name}, doc); }}]
        end
        
      end

    end
  end
end