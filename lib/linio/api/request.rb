require 'httparty'
require 'forwardable'

module Linio
  module Api
    class Request
      extend Forwardable
      include HTTParty

      base_uri "https://sellercenter-api.linio.com.mx"
      DEFAULT_OPTIONS = { verify: false }

      attr_reader :response

      def_delegators :@response, :success?

      def initialize(type, params = {})
        @type = type
        @params = params
      end

      def execute
        options = DEFAULT_OPTIONS.merge **{query: @params}
        @response = self.class.send @type, "", options
        true
      rescue StandardError => e
        false
      end
    end
  end
end
