# desc "Explaining what the task does"
# task :interapp do
#   # Task goes here
# end

namespace :interapp do
  desc "Generate a private key and its public key"
  task :keypair do
    keypair = Interapp::Cryptography.generate_keypair
    puts "Private Key:\n#{keypair[0]}\nPublic Key:\n#{keypair[1]}"
  end
end
