require 'spec_helper'

RSpec.describe Linio::Api::RequestSigner do
  let(:valid_signature) do
    '3ceb8ed91049dfc718b0d2d176fb2ed0e5fd74f76c5971f34cdab48412476041'
  end

  let(:valid_params) do
    {
      user_id: 'look@me.com',
      version: '1.0',
      action: 'FeedList',
      format: 'XML',
      timestamp: '2015-07-01T11:11:11+00:00',
      secret_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe'
    }
  end

  let(:valid_params_with_signature) do
    {
      Action: "FeedList",
      Format: "XML",
      Timestamp: "2015-07-01T11:11:11+00:00",
      UserID: "look@me.com",
      Version: "1.0",
      Signature: "3ceb8ed91049dfc718b0d2d176fb2ed0e5fd74f76c5971f34cdab48412476041"
    }
  end

  describe '#initializes' do
  end
  describe '#build_signature' do
    it 'returns a valid signature' do
      auth_obj = described_class.new(valid_params)
      auth_obj.build_signature
      expect(auth_obj.signature).to eq(valid_signature)
    end

    it 'returns all params with signature attached' do
      auth_obj = described_class.new(valid_params)
      auth_obj.build_signature
      expect(auth_obj.signed_params).to eq(valid_params_with_signature)
    end
  end
end
