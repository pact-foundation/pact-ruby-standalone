require 'pact/cli'

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

Pact::CLI.start
