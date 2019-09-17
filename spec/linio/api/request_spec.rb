RSpec.describe Linio::Api::Request do
  let(:type) { 'get' }
  let(:params_to_sign) do
    {
      action: "FeedList",
      format: "XML",
      user_id: "hola@listify.mx",
      timestamp: "2019-09-17T14:16:28-05:00",
      secret_key: "1b7ef54aa2e8f71b31697e276b3b5f75a1d4578e",
      version: "1.0",
    }
  end

  describe '#execute' do
    it 'initializes an object with valid params', :vcr do
      signer = Linio::Api::RequestSigner.new(params_to_sign)
      signer.build_signature
      signed_params = signer.signed_params

      request = described_class.new(type, signed_params)
      request.execute
      expect(request.success?).to be_truthy
    end
  end
end
