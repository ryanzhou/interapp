require 'spec_helper'

describe "POST /interapp" do
  context "with valid signature" do
    let(:payload) { "{\"test\":[\"message\",\"payload\"]}" }
    let(:signature) { "304502210096e30cdca8d21ccd425eef825216dd65edb3fc4b3a6b401a7010c653208e864202201b442c03037c8deb6e3ff27cc33f6ddc338e02923d45ada41b5d57ee7d4b8a4a" }
    let(:identifier) { "dummy" }

    before do
      @mock_handler = double("handler")
      Interapp.configure do |config|
        config.on_receive do |data, peer_identifier|
         @mock_handler.receive(data, peer_identifier)
       end
      end
    end

    it "handles the message correctly" do
      expect(@mock_handler).to receive(:receive).with({ "test" => ["message", "payload"]}, "dummy").and_return({ dummy: "response"})
      post "/interapp", payload, {
        "CONTENT_TYPE" => "application/json",
        "X-Interapp-Identifier" => identifier,
        "X-Interapp-Signature" => signature
      }
      expect(response.status).to eq(200)
      expect(response.body).to eq("{\"dummy\":\"response\"}")
    end
  end

  context "with invalid signature" do
    let(:payload) { "{\"test\":[\"message\",\"payload\"]}" }
    let(:signature) { "blahblahblah" }
    let(:identifier) { "dummy" }

    it "returns 403" do
      post "/interapp", payload, {
        "CONTENT_TYPE" => "application/json",
        "X-Interapp-Identifier" => identifier,
        "X-Interapp-Signature" => signature
      }
      expect(response.status).to eq(403)
    end
  end

  context "with unknown peer" do
    let(:payload) { "{\"test\":[\"message\",\"payload\"]}" }
    let(:signature) { "304502210096e30cdca8d21ccd425eef825216dd65edb3fc4b3a6b401a7010c653208e864202201b442c03037c8deb6e3ff27cc33f6ddc338e02923d45ada41b5d57ee7d4b8a4a" }
    let(:identifier) { "foobar" }

    it "returns 403" do
      post "/interapp", payload, {
        "CONTENT_TYPE" => "application/json",
        "X-Interapp-Identifier" => identifier,
        "X-Interapp-Signature" => signature
      }
      expect(response.status).to eq(403)
    end
  end

end
