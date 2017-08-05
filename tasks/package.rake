# For Bundler.with_clean_env
require 'bundler/setup'

PACKAGE_NAME = "pact"
VERSION = File.read('VERSION').strip
TRAVELING_RUBY_VERSION = "20150715-2.2.2"

desc "Package pact-ruby-standalone for OSX, Linux x86 and Linux x86_64"
task :package => ['package:linux:x86', 'package:linux:x86_64', 'package:osx', 'package:win32']

namespace :package do
  namespace :linux do
    desc "Package pact-ruby-standalone for Linux x86"
    task :x86 => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz"] do
      create_package(TRAVELING_RUBY_VERSION, "linux-x86")
    end

    desc "Package pact-ruby-standalone for Linux x86_64"
    task :x86_64 => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz"] do
      create_package(TRAVELING_RUBY_VERSION, "linux-x86_64")
    end
  end

  desc "Package pact-ruby-standalone for OS X"
  task :osx => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz"] do
    create_package(TRAVELING_RUBY_VERSION, "osx")
  end

  desc "Package pact-ruby-standalone for Windows x86"
  task :win32 => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-win32.tar.gz"] do
    create_package(TRAVELING_RUBY_VERSION, "win32", :windows)
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^2\.2\./
      abort "You can only 'bundle install' using Ruby 2.2, because that's what Traveling Ruby uses."
    end
    sh "rm -rf build/tmp"
    sh "mkdir -p build/tmp"
    sh "cp packaging/Gemfile packaging/Gemfile.lock build/tmp/"
    sh "mkdir -p build/tmp/lib/pact/mock_service"
    # sh "cp lib/pact/mock_service/version.rb build/tmp/lib/pact/mock_service/version.rb"
    Bundler.with_clean_env do
      sh "cd build/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
      generate_readme
    end
    sh "rm -rf build/tmp"
    sh "rm -f build/vendor/*/*/cache/*"
  end
end

file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "linux-x86")
end

file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "linux-x86_64")
end

file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "osx")
end

file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-win32.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "win32")
end

def create_package(version, target, os_type = :unix)
  package_dir = "#{PACKAGE_NAME}"
  package_name = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
  sh "rm -rf #{package_dir}"
  sh "mkdir #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"
  sh "mkdir -p #{package_dir}/bin"
  sh "cp build/README.md #{package_dir}"
  sh "cp packaging/pact-mock-service.rb #{package_dir}/lib/app/pact-mock-service.rb"
  sh "cp packaging/pact-provider-verifier.rb #{package_dir}/lib/app/pact-provider-verifier.rb"
  # sh "cp -pR lib #{package_dir}/lib/app"
  sh "mkdir #{package_dir}/lib/ruby"
  sh "tar -xzf build/traveling-ruby-#{version}-#{target}.tar.gz -C #{package_dir}/lib/ruby"

  if os_type == :unix
    sh "cp packaging/pact-mock-service.sh #{package_dir}/bin/pact-mock-service"
    sh "cp packaging/pact-provider-verifier.sh #{package_dir}/bin/pact-provider-verifier"
  else
    sh "cp packaging/pact-mock-service.bat #{package_dir}/bin/pact-mock-service.bat"
    sh "cp packaging/pact-provider-verifier.bat #{package_dir}/bin/pact-provider-verifier.bat"
  end

  sh "cp -pR build/vendor #{package_dir}/lib/"
  sh "cp packaging/Gemfile packaging/Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir #{package_dir}/lib/vendor/.bundle"
  sh "cp packaging/bundler-config #{package_dir}/lib/vendor/.bundle/config"

  remove_unnecessary_files package_dir

  if !ENV['DIR_ONLY']
    sh "mkdir -p pkg"

    if os_type == :unix
      sh "tar -czf pkg/#{package_name}.tar.gz #{package_dir}"
    else
      sh "zip -9rq pkg/#{package_name}.zip #{package_dir}"
    end

    sh "rm -rf #{package_dir}"
  end
end

def remove_unnecessary_files package_dir
  ## Reduce distribution - https://github.com/phusion/traveling-ruby/blob/master/REDUCING_PACKAGE_SIZE.md
  # Remove tests
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/test"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/tests"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/spec"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/features"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/benchmark"

  # # Remove documentation"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/README*"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/CHANGE*"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/Change*"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/COPYING*"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/LICENSE*"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/MIT-LICENSE*"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/TODO"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/*.txt"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/*.md"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/*.rdoc"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/doc"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/docs"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/example"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/examples"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/sample"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/doc-api"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.md' | xargs rm -f"

  # # Remove misc unnecessary files"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/.gitignore"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/.travis.yml"
  #
  # # Remove leftover native extension sources and compilation objects"
  # Something in here is required for windows :(
  # sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/ext/Makefile"
  # sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/ext/*/Makefile"
  # sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/ext/*/tmp"
  # sh "find #{package_dir}/lib/vendor/ruby -name '*.c' | xargs rm -f"
  # sh "find #{package_dir}/lib/vendor/ruby -name '*.cpp' | xargs rm -f"
  # sh "find #{package_dir}/lib/vendor/ruby -name '*.h' | xargs rm -f"
  # sh "find #{package_dir}/lib/vendor/ruby -name '*.rl' | xargs rm -f"
  # sh "find #{package_dir}/lib/vendor/ruby -name 'extconf.rb' | xargs rm -f"
  # sh "find #{package_dir}/lib/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
  # sh "find #{package_dir}/lib/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
  # sh "find #{package_dir}/lib/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"
  #
  # # Remove Java files. They're only used for JRuby support"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.java' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.class' | xargs rm -f"
  #
  # # Ruby Docs
  sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/*/rdoc*"
end

def generate_readme
  template = File.absolute_path("packaging/README.md.template")
  script = File.absolute_path("packaging/generate_readme_contents.rb")
  Bundler.with_clean_env do
    sh "cd build/tmp && env VERSION=#{VERSION} bundle exec ruby #{script} #{template} > ../README.md"
  end
end

def download_runtime(version, target)
  sh "cd build && curl -L -O --fail " +
    "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-#{version}-#{target}.tar.gz"
end
