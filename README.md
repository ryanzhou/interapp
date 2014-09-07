Interapp
========

Interapp is a mountable Rails engine that handles simple and secure inter-app messaging using ECDSA. Using Interapp, you can:

* Send messages signed with your private key
* Validate incoming messages against known public keys

It's important to note that Interapp does not encrypt your messages. I believe that this should the job of TLS. (Therefore, it's **strongly recommended** that you only use HTTPS endpoints in Interapp.)

If you decide to implement Interapp in your Rails application, you are trusting:

* This [Interapp gem](https://github.com/zhoutong/interapp) (or any fork you're using)
* The [ECDSA gem](https://github.com/DavidEGrayson/ruby_ecdsa) by @DavidEGrayson
* The `SecureRandom` library in Ruby

**WARNING:** This gem is not written by a cryptographer, nor has it been reviewed by one. It's your responsibility to check that this gem and all its dependencies are sufficiently secure and trustworthy for your application.

## Installation

Add the following to your Gemfile:

```ruby
gem 'interapp'
```

Install the gem:

```
bundle install
```

Then generate a pair of Interapp-formatted public and private keys:

```
rake interapp:keypair
```

That's it! You're now ready to configure your Interapp-powered application.

## Configuration

To configure your app to use Interapp, mount Interapp as an Engine in your `config/routes.rb`:

```ruby
mount Interapp::Engine => "/interapp"
```

And then, you should probably create a configuration file `config/initializers/interapp.rb` with something like this:

```ruby
Interapp.configure do |config|
  config.identifier = "dummy"
  config.private_key = "8347824e9c8e8414af57845a19eaaf28df323b9db05bb81de6cd3bbd784174a5"

  config.on_receive do |data, peer_identifier|
    puts peer_identifier
    puts data.to_yaml
  end
end
```

Of course, you should replace the private key with the one you've just generated, and write your own message handler code within the `on_receive` block.

Install this gem in all the applications that you want to use Interapp with, and generate their own public and private keys.

To add a peer, put the something like this in the config block:

```ruby
config.add_peer do |peer|
  peer.identifier = "dummy"
  peer.public_key = "02aeca3e7c706158823dd23a03373438c355cdf476fe3594364226ada0035abfea"
  peer.endpoint = "https://dummy.example.com/interapp"
end
```

The peer identifier must be the same as the identifier configured in the peer application.

## Interface

Now comes the fun part. Interapp is incredibly easy to use.

### Send a message

If you want to send a Ruby hash to a peer called "foobar", just do this:

```
Interapp.send_to "foobar", { hello: "world" }
```

As long as you've configured "foobar" correctly and added it as a peer in your configuration, this message should be signed and delivered in no time, and automatically verified, parsed and sent to the custom message handler at the other end.

## Protocol

Interapp uses simple HTTP for messaging, with the request body being the JSON payload. There are two special HTTP headers required by Interapp:

* `X-Interapp-Identifier`: Interapp uses the peer identifier to find the peer's public key.
* `X-Interapp-Signature`: This is the hex-encoded DER string of the ECDSA signature.

### Public/Private Key

For ease of configuration, public and private keys in Interapp are both stored as hex-encoded strings:

* `public_key` is a hex-encoded Point Octet binary string with compression.
* `private_key` is a hex-encoded random integer.

### Signatures

Signatures are created from the SHA-256 digest of the payload string with a random temporary key.

## Contributors

If you want to contribute to this gem, you can fork this repository and set up your development environment.

Simply clone the repo, and run `bundle exec rspec` to run all the tests.

## License

MIT license. Copyright 2014 Ryan Zhou.
