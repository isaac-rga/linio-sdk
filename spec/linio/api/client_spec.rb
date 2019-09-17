RSpec.describe Linio::Api::Client do
  let(:valid_obj_params) do
    {
      user_id: "hola@listify.mx",
      secret_key: "1b7ef54aa2e8f71b31697e276b3b5f75a1d4578e"
    }
  end

  let(:valid_req_params) { {action: "FeedList"} }

  describe '#initialize' do
    # it {expect to have secret_key}
  end

  describe '#get' do
    it 'initializes an object with valid params', :vcr do
      client = described_class.new(valid_obj_params)
      client.get(valid_req_params)
    end
  end
end
