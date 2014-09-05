# desc "Explaining what the task does"
# task :interapp do
#   # Task goes here
# end

namespace :interapp do
  desc "Generate a private key and its public key"
  task :generate_keypair do
    group = Interapp::Configuration::EC_GROUP
    private_key = 1 + SecureRandom.random_number(group.order - 1)
    puts "Private Key:\n#{private_key.to_s(16)}"
    public_key = group.generator.multiply_by_scalar(private_key)
    public_key_binary = ECDSA::Format::PointOctetString.encode(public_key, compression: true)
    puts "Public Key:\n#{public_key_binary.unpack('H*').first}"
  end
end
