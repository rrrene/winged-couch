module WingedCouch
	module Queries
    class ViewBuilder

      attr_reader :view, :model

      def initialize(view, model)
        @view = view
        @model = model
      end

      # ................................................................

      def descending(value)
        builder.with_param("descending", !!value); self
      end

      def endkey(value)
        builder.with_param("endkey", value.inspect); self
      end

      def endkey_docid(value)
        builder.with_param("endkey_docid", value); self
      end

      def group(value)
        builder.with_param("group", !!value); self
      end

      def group_level(value)
        builder.with_param("group_level", value.to_i); self
      end

      def include_docs(value)
        builder.with_param("include_docs", !!value); self
      end

      def inclusive_end(value)
        builder.with_param("inclusive_end", !!value); self
      end 

      def key(value)
        builder.with_param("key", value.inspect); self  
      end

      def limit(value)
        builder.with_param("limit", value.to_i); self  
      end

      def reduce(value)
        builder.with_param("reduce", !!value); self  
      end

      def skip(value)
        builder.with_param("skip", value.to_i); self  
      end

      def stale(value)
        builder.with_param("stale", value); self  
      end

      def startkey(value)
        builder.with_param("startkey", value.inspect); self  
      end

      def startkey_docid(value)
        builder.with_param("startkey_docid", value); self  
      end

      def update_seq(value)
        builder.with_param("update_seq", !!value); self
      end

      # .....................................................

      def count
        raw_result["total_rows"]
      end

      def all
        result
      end

      def path
        builder.path
      end

      def params
        builder.params
      end

      private

      def result
        ViewResultProcessor.new(view, model, raw_result).result
      end

      def raw_result
        builder.perform
      end

      def builder
        @builder ||= BaseBuilder.new.
          with_database(model.database).
          with_path("/_design/winged_couch/_view/#{view.view_name}")
      end

    end
  end
end