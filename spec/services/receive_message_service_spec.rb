require 'spec_helper'

describe Interapp::ReceiveMessageService do
  subject(:receive_message_service) do
    described_class.new(
      payload: "{\"test\":[\"message\",\"payload\"]}",
      peer_identifier: "dummy",
      signature: "304502210096e30cdca8d21ccd425eef825216dd65edb3fc4b3a6b401a7010c653208e864202201b442c03037c8deb6e3ff27cc33f6ddc338e02923d45ada41b5d57ee7d4b8a4a"
    )
  end

  describe ".new" do
    it "finds the peer" do
      expect(subject.peer).to be_a(Interapp::Peer)
    end

    it "loads the payload" do
      expect(subject.data).to eq({ "test" => ["message", "payload"] })
    end
  end

  describe "#perform" do
    before do
      @mock_handler = double("handler")
      Interapp.configure do |config|
        config.on_receive do |data, peer_identifier|
         @mock_handler.receive(data, peer_identifier)
       end
      end
    end

    context "with valid signature" do
      it "handles the message" do
        expect(@mock_handler).to receive(:receive).with({ "test" => ["message", "payload"]}, "dummy")
        subject.perform
      end

      it "sets the return value attribute" do
        allow(@mock_handler).to receive(:receive).with({ "test" => ["message", "payload"]}, "dummy").and_return({ dummy: "response" })
        subject.perform
        expect(subject.return_value).to eq({ dummy: "response" })
      end
    end

    context "with invalid signature" do
      before do
        subject.message.signature = "blahblahblahinvalid"
      end

      it "raises an error" do
        expect { subject.perform }.to raise_error(Interapp::SignatureInvalidError)
      end
    end
  end
end
