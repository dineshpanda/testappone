require "rails_helper"

RSpec.describe "addresses#create", type: :request do
  subject(:make_request) do
    jsonapi_post "/api/v1/addresses", payload
  end

  describe "basic create" do
    let(:params) do
      attributes_for(:address)
    end
    let(:payload) do
      {
        data: {
          type: "addresses",
          attributes: params,
        },
      }
    end

    it "works" do
      expect(AddressResource).to receive(:build).and_call_original
      expect do
        make_request
        expect(response.status).to eq(201), response.body
      end.to change { Address.count }.by(1)
    end
  end
end
