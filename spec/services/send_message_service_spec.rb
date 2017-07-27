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
    it "sends the POST request" do
      expect(RestClient).to receive(:post).with(subject.peer.endpoint, subject.message.payload, {
        content_type: 'application/json',
        "X-Interapp-Identifier" => Interapp.configuration.identifier,
        "X-Interapp-Signature" => subject.message.signature
      })
      subject.perform
    end

    it "returns parsed json response" do
      allow(RestClient).to receive(:post).and_return("{\"dummy\":\"response\"}")
      expect(subject.perform).to eq({"dummy" => "response"})
    end
  end
end
