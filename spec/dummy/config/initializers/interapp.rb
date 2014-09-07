Interapp.configure do |config|
  config.identifier = "dummy"
  config.private_key = "8347824e9c8e8414af57845a19eaaf28df323b9db05bb81de6cd3bbd784174a5"

  config.on_receive do |data, peer_identifier|
    puts peer_identifier
    puts data.to_yaml
  end

  config.add_peer do |peer|
    peer.identifier = "dummy"
    peer.public_key = "02aeca3e7c706158823dd23a03373438c355cdf476fe3594364226ada0035abfea"
    peer.endpoint = "https://dummy.example.com/interapp"
  end

  config.add_peer do |peer|
    peer.identifier = "dummy2"
    peer.public_key = "025690f4afe20e82ce8098ba8cd6b09916a80f7bf02617b7a03982f68630911535"
    peer.endpoint = "https://dummy2.example.com/interapp"
  end
end
