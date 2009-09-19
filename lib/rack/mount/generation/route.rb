require 'rack/mount/utils'

module Rack::Mount
  module Generation
    module Route #:nodoc:
      attr_reader :generation_keys

      def initialize(*args)
        super

        @required_params = {}
        @required_defaults = {}
        @generation_keys = @defaults.dup

        @conditions.each do |method, condition|
          @required_params[method] = @conditions[method].required_captures.map { |s| s.name }.reject { |s| @defaults.include?(s) }.freeze
          @required_defaults[method] = @defaults.dup
          @conditions[method].captures.inject({}) { |h, s| h.merge!(s.to_hash) }.keys.each { |name|
            @required_defaults[method].delete(name)
            @generation_keys.delete(name) if @defaults.include?(name)
          }
          @required_defaults[method].freeze
        end

        @required_params.freeze
        @required_defaults.freeze
        @generation_keys.freeze
      end

      def url(params = {}, recall = {})
        unless part = generate_method(:path_info, params, recall, @defaults)
          return
        end

        @defaults.each do |key, value|
          if params[key] == value
            params.delete(key)
          end
        end

        params.delete_if { |k, v| v.nil? }
        if params.any?
          part << "?#{Utils.build_nested_query(params)}"
        end

        part
      end

      def generate(methods, params = {}, recall = {})
        return url(params, recall) if methods == :__url__
        if methods.is_a?(Array)
          methods.map { |m| generate_method(m, params, recall, @defaults) || (return nil) }
        else
          generate_method(methods, params, recall, @defaults)
        end
      end

      private
        def generate_method(method, params, recall, defaults)
          merged = recall.merge(params)
          return nil unless condition = @conditions[method]
          return nil if condition.segments.empty?
          return nil unless @required_params[method].all? { |p| merged.include?(p) }
          return nil unless @required_defaults[method].all? { |k, v| merged[k] == v }
          condition.generate(params, recall, defaults)
        end
    end
  end
end
