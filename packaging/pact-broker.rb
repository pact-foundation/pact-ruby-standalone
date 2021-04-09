require 'pact_broker/client/cli/broker'

if ENV['PACT_BROKER_DISABLE_SSL_VERIFICATION'] == 'true' || ENV['PACT_DISABLE_SSL_VERIFICATION'] == 'true'
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  $stderr.puts "WARN: SSL verification has been disabled by a dodgy hack (reassigning the VERIFY_PEER constant to VERIFY_NONE). You acknowledge that you do this at your own risk!"
end

class Thor
  module Base
    module ClassMethods

      def basename
        # chomps the trailing .rb so it doesn't show in the help text
        File.basename($PROGRAM_NAME).split(" ").first.chomp(".rb")
      end
    end
  end
end

# Travelling Ruby sets its own CA cert bundle in lib/ruby/bin/ruby_environment
# and creates backup environment variables for the original SSL_CERT values.
# Restore the original values here *if they are present* so that we can connect to
# a broker with a custom SSL certificate.

if ENV['ORIG_SSL_CERT_DIR'] && ENV['ORIG_SSL_CERT_DIR'] != ''
  ENV['SSL_CERT_DIR'] = ENV['ORIG_SSL_CERT_DIR']
end

if ENV['ORIG_SSL_CERT_FILE'] && ENV['ORIG_SSL_CERT_FILE'] != ''
  ENV['SSL_CERT_FILE'] = ENV['ORIG_SSL_CERT_FILE']
end

PactBroker::Client::CLI::Broker.start
