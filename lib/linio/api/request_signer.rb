require 'openssl'
require 'date'
require 'uri'

module Linio
  module Api
    # Class to create an Authentication object that is used on every API call,
    #   this object parameters are included in the headers.
    class RequestSigner
      attr_reader :signature, :signed_params

      def initialize(params = {})
        @header_params = {
          'UserID': params[:user_id],
          'Version': params[:version],
          'Action': params[:action],
          'Format': params[:format],
          'Timestamp': params[:timestamp] || DateTime.now.iso8601
        }

        @query_params = params[:query] || {}
        @secret_key = params[:secret_key]
      end

      def build_signature
        compute_hmacsha_256
        build_signed_params
      end

      private

      def build_signed_params
        @signed_params = sorted_params.merge({'Signature': @signature})
      end

      def sorted_params
        (@header_params.merge @query_params).sort.to_h
      end

      def encode_sorted_params
        URI.encode_www_form(sorted_params)
      end

      def compute_hmacsha_256
        digest = OpenSSL::Digest.new('sha256')
        @signature = OpenSSL::HMAC.hexdigest(digest, @secret_key, encode_sorted_params)
      end
    end
  end
end
