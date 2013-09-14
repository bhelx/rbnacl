# encoding: binary
require "rbnacl/version"
require "rbnacl/nacl"
require "rbnacl/serializable"
require "rbnacl/key_comparator"
require "rbnacl/auth"
require "rbnacl/util"
require "rbnacl/random"
require "rbnacl/random_nonce_box"
require "rbnacl/test_vectors"

module RbNaCl
  # Oh no, something went wrong!
  #
  # This indicates a failure in the operation of a cryptographic primitive such
  # as authentication failing on an attempt to decrypt a ciphertext.  Classes
  # in the library may define more specific subclasses.
  class CryptoError < StandardError; end

  # Something, probably a key, is the wrong length
  #
  # This indicates some argument with an expected length was not that length.
  # Since this is probably a cryptographic key, you should check that!
  class LengthError < ArgumentError; end

  # An incorrect primitive has been passed to a method
  #
  # This indicates that an attempt has been made to use something (probably a key)
  # with an incorrect primitive
  class IncorrectPrimitiveError < ArgumentError; end

  # The signature was forged or otherwise corrupt
  class BadSignatureError < CryptoError; end

  # Public Key Encryption (Box): Curve25519XSalsa20Poly1305
  require "rbnacl/boxes/curve25519xsalsa20poly1305"
  require "rbnacl/boxes/curve25519xsalsa20poly1305/private_key"
  require "rbnacl/boxes/curve25519xsalsa20poly1305/public_key"

  # Secret Key Encryption (SecretBox): XSalsa20Poly1305
  require "rbnacl/secret_boxes/xsalsa20poly1305"

  # Digital Signatures: Ed25519
  require "rbnacl/signatures/ed25519/signing_key"
  require "rbnacl/signatures/ed25519/verify_key"

  # Diffie-Hellman: Curve25519
  require "rbnacl/points/curve25519"

  # One-time Authentication: Poly1305
  require "rbnacl/authenticators/poly1305"

  # Hash functions: SHA256/512 and Blake2b
  require "rbnacl/hash"
  require "rbnacl/hash/blake2b"

  # HMAC: SHA256 and SHA512256
  require "rbnacl/hmac/sha256"
  require "rbnacl/hmac/sha512256"

  #
  # Bind aliases used by the public API
  #
  Box         = Boxes::Curve25519XSalsa20Poly1305
  PrivateKey  = Boxes::Curve25519XSalsa20Poly1305::PrivateKey
  PublicKey   = Boxes::Curve25519XSalsa20Poly1305::PublicKey
  SecretBox   = SecretBoxes::XSalsa20Poly1305
  SigningKey  = Signatures::Ed25519::SigningKey
  VerifyKey   = Signatures::Ed25519::VerifyKey
  Point       = Points::Curve25519
  OneTimeAuth = Authenticators::Poly1305
end

# Select platform-optimized versions of algorithms
Thread.exclusive { RbNaCl::NaCl.sodium_init }

# Perform self test on load
require "rbnacl/self_test"
