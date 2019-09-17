module Linio
  module Api
    class Client

      def initialize(params = {})
        @user_id = params[:user_id]
        @secret_key = params[:secret_key]
        @version = params[:version] || '1.0'
        @format = params[:format] || 'XML'
      end

      def get(params)
        sign_params(params)
        process_request('get')
      end

      def post(params)
        sign_params(params)
        process_request('post')
      end

      private

      def process_request(type)
        request = Request.new(type, @request_params)
        request.execute
      end

      def sign_params(params)
        signer = RequestSigner.new(user_id: @user_id,
                                   secret_key: @secret_key,
                                   action: params[:action],
                                   version: @version,
                                   format: @format,
                                   query: params[:query])
        signer.build_signature
        @request_params = signer.signed_params
      end
    end
  end
end
