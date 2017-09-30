require 'erb'
require 'pact/version'
require 'pact/mock_service/version'
require 'pact/support/version'
require 'pact/provider_verifier/version'
require 'pact_broker/client/version'

puts ERB.new(ARGF.read).result(binding)
