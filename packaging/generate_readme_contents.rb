require 'erb'
require 'pact/version'
require 'pact/mock_service/version'
require 'pact/support/version'
require 'pact/provider/proxy/version'
require 'pact/provider_verifier/version'

puts ERB.new(ARGF.read).result(binding)
