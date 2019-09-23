require 'ostruct'

module Linio
  module Api
    class Response
      attr_reader :raw, :body, :head, :error

      def initialize(params = {})
        @raw = params[:raw]
      end

      def process
        return process_error unless success?

        process_head
        process_body
        true
      end

      def process_head
        @head = @raw.parsed_response.dig("SuccessResponse", "Head")
      end

      def process_body
        @body = @raw.parsed_response.dig("SuccessResponse", "Body")
      end

      def success?
        @raw.success? && !@raw.parsed_response.dig("SuccessResponse").nil?
      end

      def process_error
        @error = true
        if !@raw.parsed_response.dig("ErrorResponse").nil?
          @head = @raw.parsed_response.dig("ErrorResponse", "Head")
        end
      end
    end
  end
end
