require 'spec_helper'

describe Interapp::SendMessageService do
  subject(:send_message_service) { described_class.new(data: { test: ["message", "payload"]}, peer_identifier: "dummy") }

  describe ".new" do
    it "finds the peer" do
      expect(subject.peer).to be_a(Interapp::Peer)
    end

    it "dumps the payload" do
      expect(subject.payload).to be_a(String)
    end

    it "signs the message" do
      expect(subject.message.signature).to be_a(String)
    end
  end

  describe "#perform" do
    it "sends the POST request and return parsed json response" do
      stub_request(:post, "https://dummy.example.com/interapp")
        .with(
          body: "{\"test\":[\"message\",\"payload\"]}",
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'X-Interapp-Identifier' => Interapp.configuration.identifier,
            'X-Interapp-Signature' => subject.message.signature
          }
        ).to_return(
          status: 200,
          body: "{\"dummy\":\"response\"}",
          headers: {}
        )
      expect(subject.perform).to eq({"dummy" => "response"})
    end
  end
end
