require 'pactflow/client/cli/pactflow'

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

Pactflow::Client::CLI::Pactflow.start
