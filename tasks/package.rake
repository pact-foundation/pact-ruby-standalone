# For Bundler.with_unbundled_env
require 'bundler/setup'

PACKAGE_NAME = "pact"
VERSION = File.read('VERSION').strip
TRAVELING_RUBY_VERSION = "20230605-3.2.2"
TRAVELING_RUBY_PKG_DATE = TRAVELING_RUBY_VERSION.split("-").first
TRAVELING_RB_VERSION = TRAVELING_RUBY_VERSION.split("-").last
RUBY_COMPAT_VERSION = TRAVELING_RB_VERSION.split(".").first(2).join(".") + ".0"
RUBY_MAJOR_VERSION = TRAVELING_RB_VERSION.split(".").first.to_i
RUBY_MINOR_VERSION = TRAVELING_RB_VERSION.split(".")[1].to_i
PLUGIN_CLI_VERSION = "0.1.0"
MOCK_SERVER_CLI_VERSION = "1.0.0"
VERIFIER_CLI_VERSION = "0.10.6"
STUB_SERVER_CLI_VERSION = "0.5.3"
# NATIVE_GEMS=[ 'ffi-1.15.5' ] 
NATIVE_GEMS=[ ] 
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
    if RUBY_VERSION !~ /^#{RUBY_MAJOR_VERSION}\.#{RUBY_MINOR_VERSION}\./
      abort "You can only 'bundle install' using Ruby #{RUBY_VERSION}, because that's what Traveling Ruby uses."
    end
    sh "rm -rf build/tmp"
    sh "mkdir -p build/tmp"
    sh "cp packaging/Gemfile packaging/Gemfile.lock build/tmp/"
    sh "mkdir -p build/tmp/lib/pact/mock_service"
    # sh "cp lib/pact/mock_service/version.rb build/tmp/lib/pact/mock_service/version.rb"
    Bundler.with_unbundled_env do
      sh "cd build/tmp && env bundle lock --add-platform x64-mingw32 && bundle config set --local path '../vendor' && env BUNDLE_DEPLOYMENT=true bundle install"
      generate_readme
    end
    sh "rm -rf build/tmp"
    sh "rm -rf build/vendor/*/*/cache/*"
  end

  task :generate_readme do
    Bundler.with_unbundled_env do
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
  # From https://curl.se/docs/caextract.html # Updated 08/06/23
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
  # ❯ du -sh pkg/*
  # 37M    pkg/pact
#   9.0M    pkg/pact-2.0.2-linux-arm64.tar.gz
#   10M    pkg/pact-2.0.2-linux-x86_64.tar.gz
#  9.0M    pkg/pact-2.0.2-osx-arm64.tar.gz
#   10M    pkg/pact-2.0.2-osx-x86_64.tar.gz
#   11M    pkg/pact-2.0.2-windows-x86.zip
#   12M    pkg/pact-2.0.2-windows-x86_64.zip

  # remove_possibly_necessary_files package_dir, package_target
  # ❯ du -sh pkg/*
  #  28M    pkg/pact
  # 7.0M    pkg/pact-2.0.2-linux-arm64.tar.gz
  # 7.1M    pkg/pact-2.0.2-linux-x86_64.tar.gz
  # 7.0M    pkg/pact-2.0.2-osx-arm64.tar.gz
  # 7.0M    pkg/pact-2.0.2-osx-x86_64.tar.gz
  # 9.3M    pkg/pact-2.0.2-windows-x86.zip
  # 9.8M    pkg/pact-2.0.2-windows-x86_64.zip

  ## File sizes after adding extensions
  download_and_unpack_ext package_dir, package_target, NATIVE_GEMS
  # ❯ du -sh pkg/*
  # 19M    pkg/pact-2.0.2-linux-arm64.tar.gz
  # 19M    pkg/pact-2.0.2-linux-x86_64.tar.gz
  # 19M    pkg/pact-2.0.2-osx-arm64.tar.gz
  # 19M    pkg/pact-2.0.2-osx-x86_64.tar.gz
  # 21M    pkg/pact-2.0.2-windows-x86.zip
  # 21M    pkg/pact-2.0.2-windows-x86_64.zip

  ## Install rust based tools.
  
  # install_plugin_cli package_dir, package_target
  # install_mock_server_cli package_dir, package_target
  # install_verifier_cli package_dir, package_target
  # install_stub_server_cli package_dir, package_target
  
  ## File sizes post install.
  ##
  # ❯ du -sh pkg/*
  ## 49M    pkg/pact-2.0.2-linux-arm64.tar.gz
  ## 50M    pkg/pact-2.0.2-linux-x86_64.tar.gz
  ## 42M    pkg/pact-2.0.2-osx-arm64.tar.gz
  ## 43M    pkg/pact-2.0.2-osx-x86_64.tar.gz
  ## 21M    pkg/pact-2.0.2-windows-x86.zip
  ## 42M    pkg/pact-2.0.2-windows-x86_64.zip
 

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

def remove_possibly_necessary_files(package_dir, package_target)
  unless package_target.include? 'windows'
    sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/site_ruby/#{RUBY_COMPAT_VERSION}/bundler"
    sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/#{RUBY_COMPAT_VERSION}/bundler"
    sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/#{RUBY_COMPAT_VERSION}/rubygems"
    sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans"
  end
  if package_target.include? 'windows'
    # sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/site_ruby/#{RUBY_COMPAT_VERSION}/bundler"
    # sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/#{RUBY_COMPAT_VERSION}/rubygems"
    sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/gems/#{RUBY_COMPAT_VERSION}/gems"
    # sh "rm -rf #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans"
  end

  # unless package_target.include? 'windows'
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/cp949*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/euc_*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/shift_jis*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/koi8_*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/emacs*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/gb*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/big5*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/jap*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/emo*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/chi*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/ko*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/esc*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/cesu*"
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/ebc*"
  # end
  unless package_target.include? 'osx'
    sh "rm -f #{package_dir}/lib/ruby/lib/ruby/*/*/enc/trans/utf_mac*"
  end
end

def download_and_unpack_ext(package_dir, package_target, native_gems)
  # no native gems for windows, so we exclude packing them here
  unless package_target.include? 'windows'
    native_gems.each { |native_gem| 
    sh "cd #{package_dir}/lib/vendor/ruby && \
      curl -L -O --fail https://github.com/YOU54F/traveling-ruby/releases/download/rel-#{TRAVELING_RUBY_PKG_DATE}/traveling-ruby-gems-#{TRAVELING_RUBY_VERSION}-#{package_target}-#{native_gem}.tar.gz && \
    ls && pwd && \
    tar xzf traveling-ruby-gems-#{TRAVELING_RUBY_VERSION}-#{package_target}-#{native_gem}.tar.gz && \
    tar xzf traveling-ruby-gems-#{TRAVELING_RUBY_VERSION}-#{package_target}-#{native_gem}.tar.gz && \
    rm traveling-ruby-gems-#{TRAVELING_RUBY_VERSION}-#{package_target}-#{native_gem}.tar.gz" }
    end
end

def generate_readme
  template = File.absolute_path("packaging/README.md.template")
  script = File.absolute_path("packaging/generate_readme_contents.rb")
  Bundler.with_unbundled_env do
    sh "cd build/tmp && env VERSION=#{VERSION} bundle exec ruby #{script} #{template} > ../README.md"
  end
end

def download_runtime(version, target)
  sh "cd build && curl -L -O --fail " +
    "https://github.com/YOU54F/traveling-ruby/releases/download/rel-#{TRAVELING_RUBY_PKG_DATE}/traveling-ruby-#{version}-#{target}.tar.gz"
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

def install_mock_server_cli(package_dir, package_target)
  case package_target
  when "linux-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact_mock_server_cli.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_mock_server_cli-v#{MOCK_SERVER_CLI_VERSION}/pact_mock_server_cli-linux-x86_64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_mock_server_cli.gz"
    sh "chmod +x #{package_dir}/bin/pact_mock_server_cli"
  when "linux-arm64"
    sh "curl -L -o #{package_dir}/bin/pact_mock_server_cli.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_mock_server_cli-v#{MOCK_SERVER_CLI_VERSION}/pact_mock_server_cli-linux-aarch64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_mock_server_cli.gz"
    sh "chmod +x #{package_dir}/bin/pact_mock_server_cli"
  when "osx-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact_mock_server_cli.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_mock_server_cli-v#{MOCK_SERVER_CLI_VERSION}/pact_mock_server_cli-osx-x86_64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_mock_server_cli.gz"
    sh "chmod +x #{package_dir}/bin/pact_mock_server_cli"
  when "osx-arm64"
    # No aarch64 release available yet, see https://github.com/pact-foundation/pact-reference/issues/289
      sh "curl -L -o #{package_dir}/bin/pact_mock_server_cli.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_mock_server_cli-v#{MOCK_SERVER_CLI_VERSION}/pact_mock_server_cli-osx-x86_64.gz"
    # sh "curl -L -o #{package_dir}/bin/pact_mock_server_cli.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_mock_server_cli-v#{MOCK_SERVER_CLI_VERSION}/pact_mock_server_cli-osx-aarch64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_mock_server_cli.gz"
    sh "chmod +x #{package_dir}/bin/pact_mock_server_cli"
  when "windows-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact_mock_server_cli.exe.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_mock_server_cli-v#{MOCK_SERVER_CLI_VERSION}/pact_mock_server_cli-windows-x86_64.exe.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_mock_server_cli.exe.gz"
    sh "chmod +x #{package_dir}/bin/pact_mock_server_cli.exe"
  end
end
def install_verifier_cli(package_dir, package_target)
  case package_target
  when "linux-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact_verifier_cli.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v#{VERIFIER_CLI_VERSION}/pact_verifier_cli-linux-x86_64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_verifier_cli.gz"
    sh "chmod +x #{package_dir}/bin/pact_verifier_cli"
  when "linux-arm64"
    sh "curl -L -o #{package_dir}/bin/pact_verifier_cli.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v#{VERIFIER_CLI_VERSION}/pact_verifier_cli-linux-aarch64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_verifier_cli.gz"
    sh "chmod +x #{package_dir}/bin/pact_verifier_cli"
  when "osx-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact_verifier_cli.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v#{VERIFIER_CLI_VERSION}/pact_verifier_cli-osx-x86_64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_verifier_cli.gz"
    sh "chmod +x #{package_dir}/bin/pact_verifier_cli"
  when "osx-arm64"
    sh "curl -L -o #{package_dir}/bin/pact_verifier_cli.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v#{VERIFIER_CLI_VERSION}/pact_verifier_cli-osx-aarch64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_verifier_cli.gz"
    sh "chmod +x #{package_dir}/bin/pact_verifier_cli"
  when "windows-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact_verifier_cli.exe.gz https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v#{VERIFIER_CLI_VERSION}/pact_verifier_cli-windows-x86_64.exe.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact_verifier_cli.exe.gz"
    sh "chmod +x #{package_dir}/bin/pact_verifier_cli.exe"
  end
end
def install_stub_server_cli(package_dir, package_target)
  case package_target
  when "linux-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact-stub-server.gz https://github.com/pact-foundation/pact-stub-server/releases/download/v#{STUB_SERVER_CLI_VERSION}/pact-stub-server-linux-x86_64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-stub-server.gz"
    sh "chmod +x #{package_dir}/bin/pact-stub-server"
  when "linux-arm64"
    sh "curl -L -o #{package_dir}/bin/pact-stub-server.gz https://github.com/pact-foundation/pact-stub-server/releases/download/v#{STUB_SERVER_CLI_VERSION}/pact-stub-server-linux-aarch64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-stub-server.gz"
    sh "chmod +x #{package_dir}/bin/pact-stub-server"
  when "osx-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact-stub-server.gz https://github.com/pact-foundation/pact-stub-server/releases/download/v#{STUB_SERVER_CLI_VERSION}/pact-stub-server-osx-x86_64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-stub-server.gz"
    sh "chmod +x #{package_dir}/bin/pact-stub-server"
  when "osx-arm64"
    sh "curl -L -o #{package_dir}/bin/pact-stub-server.gz https://github.com/pact-foundation/pact-stub-server/releases/download/v#{STUB_SERVER_CLI_VERSION}/pact-stub-server-osx-aarch64.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-stub-server.gz"
    sh "chmod +x #{package_dir}/bin/pact-stub-server"
  when "windows-x86_64"
    sh "curl -L -o #{package_dir}/bin/pact-stub-server.exe.gz https://github.com/pact-foundation/pact-stub-server/releases/download/v#{STUB_SERVER_CLI_VERSION}/pact-stub-server-windows-x86_64.exe.gz"
    sh "gunzip -N -f #{package_dir}/bin/pact-stub-server.exe.gz"
    sh "chmod +x #{package_dir}/bin/pact-stub-server.exe"
  end
end