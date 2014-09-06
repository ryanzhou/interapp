require 'spec_helper'

describe Interapp::Message do
  let(:payload) { '{ "test": ["message", "payload"] }' }
  let(:keypair) { Interapp::Cryptography.generate_keypair }
  let(:peer) { Interapp::Peer.new(identifier: "test_peer", public_key: keypair[1])}
  subject(:message) { described_class.new(payload: payload, peer: peer) }

  describe ".new" do
    it "stores payload and peer in instance variable" do
      expect(subject.payload).to eq(payload)
      expect(subject.peer).to eq(peer)
    end
  end

  describe "#verify" do
    context "with a valid signature" do
      before do
        subject.signature = Interapp::Cryptography.sign(payload, keypair[0].to_i(16)).unpack("H*").first
      end

      it "verifies as true" do
        expect(subject.verify).to be_true
      end
    end

    context "with an invalid signature" do
      before do
        subject.signature = Interapp::Cryptography.sign("foo bar baz", keypair[0].to_i(16)).unpack("H*").first
      end

      it "verifies as false" do
        expect(subject.verify).to be_false
      end
    end
  end

  describe "#sign" do
    before do
      Interapp.private_key = keypair[0]
      subject.sign
    end

    it "stores the signature in hex" do
      expect(subject.signature).to be_present
      expect(subject.signature).to be_a(String)
    end

    it "verifies against itself" do
      expect(subject.verify).to be_true
    end
  end
end
