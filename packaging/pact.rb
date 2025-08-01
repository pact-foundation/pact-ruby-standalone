#!/usr/bin/env ruby
# frozen_string_literal: true

INTERNAL_APP = ARGV[0].to_s
FILENAME = File.basename($PROGRAM_NAME).split.first.chomp(".rb")

case ARGV[0]
when "pact"
  ARGV.shift
  require "pact/cli"
  Pact::CLI.start
when "pactflow"
  ARGV.shift
  require "pactflow/client/cli/pactflow"
  Pactflow::Client::CLI::Pactflow.start
when "stub-service"
  ARGV.shift
  require "pact/stub_service/cli"
  Pact::StubService::CLI.start
when "provider-verifier"
  ARGV.shift
  ENV["PACT_EXECUTING_LANGUAGE"] ||= "unknown"
  require "pact/provider_verifier/cli/verify"
  Pact::ProviderVerifier::CLI::Verify.start
when "mock-service"
  ARGV.shift
  require "pact/mock_service/cli"
  Pact::MockService::CLI.start
when "message"
  ARGV.shift
  require "pact/message/cli"
  Pact::Message::CLI.start
when "broker", "pact-broker"
  ARGV.shift
  require "pact_broker/client/cli/broker"
  if ENV["PACT_BROKER_DISABLE_SSL_VERIFICATION"] == "true" || ENV["PACT_DISABLE_SSL_VERIFICATION"] == "true"
    require "openssl"
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    warn "
    WARN: SSL verification has been disabled by a dodgy hack
    (reassigning the VERIFY_PEER constant to VERIFY_NONE).
    You acknowledge that you do this at your own risk!
    "
  end
  PactBroker::Client::CLI::Broker.start
when 'plugin'
      ARGV.shift
      output = `#{File.expand_path("../../bin/pact-plugin-cli", __dir__)} #{ARGV.join(" ")}`
      exit_status = $?.exitstatus
      puts output
      exit(exit_status)
when 'verifier'
      ARGV.shift
      output = `#{File.expand_path("../../bin/pact_verifier_cli", __dir__)} #{ARGV.join(" ")}`
      exit_status = $?.exitstatus
      puts output
      exit(exit_status)
when 'mock-server'
      ARGV.shift
      IO.popen([File.expand_path("../../bin/pact_mock_server_cli", __dir__), *ARGV], err: [:child, :out]) do |io|
        while (line = io.gets)
          $stdout.write(line)
        end
        exit_status = Process.wait2(io.pid)[1].exitstatus
        exit(exit_status)
      end
when 'stub-server'
  ARGV.shift
  IO.popen([File.expand_path("../../bin/pact-stub-server", __dir__), *ARGV], err: [:child, :out]) do |io|
    while (line = io.gets)
      $stdout.write(line)
    end
    exit_status = Process.wait2(io.pid)[1].exitstatus
    exit(exit_status)
  end
when 'pactflow-ai'
  ARGV.shift
  IO.popen([File.expand_path("../../bin/pactflow-ai", __dir__), *ARGV], err: [:child, :out]) do |io|
    while (line = io.gets)
      $stdout.write(line)
    end
    exit_status = Process.wait2(io.pid)[1].exitstatus
    exit(exit_status)
  end
else
  puts "available commands:"
  puts "__________________"
  puts "#{FILENAME} help"
  puts "#{FILENAME} broker"
  puts "#{FILENAME} mock-server"
  puts "#{FILENAME} pact"
  puts "#{FILENAME} pact-broker"
  puts "#{FILENAME} pactflow"
  puts "#{FILENAME} pactflow-ai"
  puts "#{FILENAME} plugin"
  puts "#{FILENAME} stub-server"
  puts "#{FILENAME} verifier"
  puts "#{FILENAME} message (legacy)"
  puts "#{FILENAME} mock-service (legacy)"
  puts "#{FILENAME} stub-service (legacy)"
  puts "#{FILENAME} provider-verifier (legacy)"
end