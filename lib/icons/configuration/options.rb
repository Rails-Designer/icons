# frozen_string_literal: true

module Icons
  class Configuration
    class Options < Hash
      def method_missing(method_name, *args)
        if method_name.to_s.end_with?("=")
          key = method_name.to_s.chomp("=").to_sym
          self[key] = args.first
        else
          self[method_name]
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        true
      end
    end
  end
end
