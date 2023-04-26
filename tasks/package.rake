# For Bundler.with_clean_env
require 'bundler/setup'

PACKAGE_NAME = "pact"
VERSION = File.read('VERSION').strip
TRAVELING_RUBY_VERSION = "20230508-3.2.2"
PLUGIN_CLI_VERSION = "0.1.0"

desc "Package pact-ruby-standalone for OSX, Linux x86_64 and windows x86_64"
task :package => ['package:linux:x86_64','package:linux:arm64', 'package:osx:x86_64', 'package:osx:arm64','package:windows:x86_64','package:windows:x86']

namespace :package do
  namespace :linux do
    desc "Package pact-ruby-standalone for Linux x86_64"
    task :x86_64 => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz"] do
      create_package(TRAVELING_RUBY_VERSION, "linux-x86_64", "linux-x86_64", :unix)
    end

    desc "Package pact-ruby-standalone for Linux arm64"
    task :arm64 => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-arm64.tar.gz"] do
      create_package(TRAVELING_RUBY_VERSION, "linux-arm64", "linux-arm64", :unix)
    end
  end

  namespace :osx do
  desc "Package pact-ruby-standalone for OS X x86_64"
  task :x86_64 => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-x86_64.tar.gz"] do
    create_package(TRAVELING_RUBY_VERSION, "osx-x86_64", "osx-x86_64", :unix)
  end

  desc "Package pact-ruby-standalone for OS X arm64"
  task :arm64 => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-arm64.tar.gz"] do
    create_package(TRAVELING_RUBY_VERSION, "osx-arm64", "osx-arm64", :unix)
  end
  end
  namespace :windows do
    desc "Package pact-ruby-standalone for windows x86_64"
    task :x86_64 => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-windows-x86_64.tar.gz"] do
      create_package(TRAVELING_RUBY_VERSION, "windows-x86_64", "windows-x86_64", :windows)
    end
    desc "Package pact-ruby-standalone for windows x86"
    task :x86 => [:bundle_install, "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-windows-x86.tar.gz"] do
      create_package(TRAVELING_RUBY_VERSION, "windows-x86", "windows-x86", :windows)
    end
  end
  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^3\.2\./
      abort "You can only 'bundle install' using Ruby 3.2.2, because that's what Traveling Ruby uses."
    end
    sh "rm -rf build/tmp"
    sh "mkdir -p build/tmp"
    sh "cp packaging/Gemfile packaging/Gemfile.lock build/tmp/"
    sh "mkdir -p build/tmp/lib/pact/mock_service"
    # sh "cp lib/pact/mock_service/version.rb build/tmp/lib/pact/mock_service/version.rb"
    Bundler.with_clean_env do
      sh "cd build/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle lock --add-platform x64-mingw32 && env BUNDLE_IGNORE_CONFIG=1 BUNDLE_DEPLOYMENT=true bundle install --path ../vendor"
      generate_readme
    end
    sh "rm -rf build/tmp"
    sh "rm -rf build/vendor/*/*/cache/*"
  end

  task :generate_readme do
    Bundler.with_clean_env do
      sh "mkdir -p build/tmp"
      sh "cp packaging/Gemfile packaging/Gemfile.lock build/tmp/"
      sh "cd build/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
      generate_readme
    end
  end
end

file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "linux-x86_64")
end

file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-arm64.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "linux-arm64")
end

file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-x86_64.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "osx-x86_64")
end

file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-arm64.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "osx-arm64")
end

file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-windows-x86_64.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "windows-x86_64")
end
file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-windows-x86.tar.gz" do
  download_runtime(TRAVELING_RUBY_VERSION, "windows-x86")
end

def create_package(version, source_target, package_target, os_type)
  package_dir = "#{PACKAGE_NAME}"
  package_name = "#{PACKAGE_NAME}-#{VERSION}-#{package_target}"
  sh "rm -rf #{package_dir}"
  sh "mkdir #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"
  sh "mkdir -p #{package_dir}/bin"
  sh "cp build/README.md #{package_dir}"
  sh "cp packaging/pact*.rb #{package_dir}/lib/app"

  # sh "cp -pR lib #{package_dir}/lib/app"
  sh "mkdir #{package_dir}/lib/ruby"
  sh "tar -xzf build/traveling-ruby-#{version}-#{source_target}.tar.gz -C #{package_dir}/lib/ruby"
  # From https://curl.se/docs/caextract.html
  sh "cp packaging/cacert.pem #{package_dir}/lib/ruby/lib/ca-bundle.crt"

  case os_type
  when :unix
    Dir.chdir('packaging'){ Dir['pact*.sh'] }.each do | name |
      sh "cp packaging/#{name} #{package_dir}/bin/#{name.chomp('.sh')}"
    end
  when :windows
    sh "cp packaging/pact*.bat #{package_dir}/bin"
  else
    raise "We don't serve their kind (#{os_type}) here!"
  end

  sh "cp -pR build/vendor #{package_dir}/lib/"
  sh "cp packaging/Gemfile packaging/Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir #{package_dir}/lib/vendor/.bundle"
  sh "cp packaging/bundler-config #{package_dir}/lib/vendor/.bundle/config"

  remove_unnecessary_files package_dir
  install_plugin_cli package_dir, package_target

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

  # Remove documentation"
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

  # Remove misc unnecessary files"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/.gitignore"
  sh "rm -rf #{package_dir}/lib/vendor/ruby/*/gems/*/.travis.yml"

  # Remove leftover native extension sources and compilation objects"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/ext/Makefile"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/ext/*/Makefile"
  sh "rm -f #{package_dir}/lib/vendor/ruby/*/gems/*/ext/*/tmp"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.c' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.cpp' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.h' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.rl' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby -name 'extconf.rb' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"

  # Remove Java files. They're only used for JRuby support"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.java' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.class' | xargs rm -f"

  # Ruby Docs
  sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/*/rdoc*"

  # Website files
  sh "find #{package_dir}/lib/vendor/ruby -name '*.html' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.css' | xargs rm -f"
  sh "find #{package_dir}/lib/vendor/ruby -name '*.svg' | xargs rm -f"

  # Uncommonly used encodings
  sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/cp949*"
  sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/euc_*"
  sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/shift_jis*"
  sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/koi8_*"
  sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/emacs*"
  sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/gb*"
  sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/big5*"
  # sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/windows*"
  # sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/utf_16*"
  # sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/utf_32*"
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
    "https://github.com/YOU54F/traveling-ruby/releases/download/rel-20230508/traveling-ruby-#{version}-#{target}.tar.gz"
end

def install_plugin_cli(package_dir, package_target)
  case package_target
  when "linux-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact-plugin-cli.gz https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v#{PLUGIN_CLI_VERSION}/pact-plugin-cli-linux-x86_64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-plugin-cli.gz"
    sh "chmod +x #{package_dir}/bin/pact-plugin-cli"
  when "linux-arm64"
    sh "curl -L -o #{package_dir}/bin/pact-plugin-cli.gz https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v#{PLUGIN_CLI_VERSION}/pact-plugin-cli-linux-aarch64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-plugin-cli.gz"
    sh "chmod +x #{package_dir}/bin/pact-plugin-cli"
  when "osx-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact-plugin-cli.gz https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v#{PLUGIN_CLI_VERSION}/pact-plugin-cli-osx-x86_64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-plugin-cli.gz"
    sh "chmod +x #{package_dir}/bin/pact-plugin-cli"
  when "osx-arm64"
    sh "curl -L -o #{package_dir}/bin/pact-plugin-cli.gz https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v#{PLUGIN_CLI_VERSION}/pact-plugin-cli-osx-aarch64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-plugin-cli.gz"
    sh "chmod +x #{package_dir}/bin/pact-plugin-cli"
  when "windows-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact-plugin-cli.exe.gz https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v#{PLUGIN_CLI_VERSION}/pact-plugin-cli-windows-x86_64.exe.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-plugin-cli.exe.gz"
    sh "chmod +x #{package_dir}/bin/pact-plugin-cli.exe"
  end
end