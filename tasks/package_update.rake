module PactRubyStandalone

  extend self

  def update
    Dir.chdir('packaging') do
      Bundler.with_clean_env do
        output = `bundle update 2>&1`
        $stdout.puts output
        if $? == 0
          commit(commit_message(output))
        else
          $stderr.puts "Error updating bundle"
        end
      end
    end
  end

  def commit(message)
    "git add .".tap { |it| puts it }.tap { |it| system it }
    "git commit -m \"#{message}\"".tap { |it| puts it }.tap { |it| system it }
  end

  def commit_message(output)
    pact_updates = output
      .split("\n")
      .select{|l|l =~ /pact.*\(was\s/}
      .collect(&:split)
      .collect{|w| "#{w[1]} #{w[2]}"}
      .uniq
      .join(", ")

    if pact_updates.size > 0
      "feat(gems): update to #{pact_updates}"
    else
      "feat(gems): update non-pact gems"
    end
  end
end

namespace :package do
  task :update do
    PactRubyStandalone.update
  end
end
