module WingedCouch
  module Native
    module Documents
      module Inspection

        def inspect
          inspected_data = ActiveSupport::OrderedHash.new
          inspected_data[:database] = database.name
          inspected_data[:_id] = @data[:_id]
          inspected_data[:_rev] = @data[:_rev]
          @data.except(:_rev, :_id).each { |k, v| inspected_data[k] = v }
          "#<#{self.class.name} #{inspected_data.map { |k,v| "#{k}=#{v.inspect}" }.join(", ")}>"
        end

        alias_method :to_s,   :inspect
        alias_method :to_str, :inspect

      end
    end
  end
end