require 'erb'
require 'pact/version'
require 'pact/mock_service/version'
require 'pact/support/version'
require 'pact/provider_verifier/version'
require 'pact_broker/client/version'

pact_mock_service_usage = `bundle exec pact-mock-service help` + `bundle exec pact-mock-service help service`
pact_stub_service_usage = `bundle exec pact-stub-service help`
pact_provider_verifier_usage = `bundle exec pact-provider-verifier help`
pact_publish_usage = `bundle exec pact-broker help publish`
pact_broker_can_i_deploy = `bundle exec pact-broker help can-i-deploy`
puts ERB.new(ARGF.read).result(binding)
