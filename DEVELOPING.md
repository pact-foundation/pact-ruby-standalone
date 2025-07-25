## Packaging

pact-standalone is packaged with `traveling-ruby`

### Building the `traveling-ruby` runtime

1. Build the traveling ruby runtime
   1. `git clone git@github.com:YOU54F/traveling-ruby.git`
   2. `git checkout ci`

For macOS - it will build for arm64 or x86_64 depending on your processor

    cd osx
    rake stash_conflicting_paths
    rake --trace
    rake unstash_conflicting_paths

For macOS x86_64 on an m1 machine

    sudo softwareupdate --install-rosetta --agree-to-license
    cd osx
    rake stash_conflicting_paths
    arch -x86_64 rake --trace
    rake unstash_conflicting_paths

For Linux

These are built via docker images, using [Phusions Holy Build Box](https://github.com/phusion/holy-build-box) so don't have to be built on a linux host. You can skip the `rake image` step, and it will pull from the image from Dockerhub

For Linux x86_64

    cd linux
    ARCHITECTURES="x86_64" rake image
    ARCHITECTURES="x86_64" rake

For Linux arm64

    cd linux
    ARCHITECTURES="arm64" rake image
    ARCHITECTURES="arm64" rake

For Windows

These dont package ruby gems, just the ruby runtime.

Script is designed to run on Linux, but can be run on macOS or windows.

1. macOS users will need `7zz` as an alias for `7z` - `brew install sevenzip`
2. linux users will need `7z`
3. windows users will need a `bash` shell, or prefix commands with `bash -c 'command'`
   1. You'll also need to modify the commands below, for the necessary version
   2. Happy to accept a PR to make it more powershell/cmd prompt friendly

For windows x86_64

    cd windows
    bash -c 'mkdir -p cache output/3.3.9'
    bash -c './build-ruby -a x86 -r 3.3.9 cache output/3.3.9'
    bash -c './package -r traveling-ruby-20230428-3.3.9-x86-windows.tar.gz output/3.3.9'

For windows x86

    bash -c 'mkdir -p cache output/3.3.9'
    bash -c './build-ruby -a x86_64 -r 3.3.9 cache output/3.3.9'
    bash -c './package -r traveling-ruby-20230428-3.3.9-x86_64-windows.tar.gz output/3.3.9'

### Building the pact-standalone packages

The following steps are the same, whether you are using the published traveling-ruby binaries, or you have built your own

Setup your gems

    bundle install

Build all the pact-standalone packages

    bundle exec rake package

Build only selected platforms

    bundle exec rake package:linux:arm64
    bundle exec rake package:linux:x64
    bundle exec rake package:osx:arm64
    bundle exec rake package:osx:x64
    bundle exec rake package:windows:x64
    bundle exec rake package:windows:x86

#### Using your own built `traveling-ruby` packages

1. in `tasks/package.rake`
   1. comment out the `download_runtime` line, for whichever binary you don't want to want to download from the uploaded source but instead, use your own

    ```ruby
    file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
    # download_runtime(TRAVELING_RUBY_VERSION, "linux-x86_64")
    end

    file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-arm64.tar.gz" do
    # download_runtime(TRAVELING_RUBY_VERSION, "linux-arm64")
    end

    file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-x86_64.tar.gz" do
    # download_runtime(TRAVELING_RUBY_VERSION, "osx-x86_64")
    end

    file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-arm64.tar.gz" do
    # download_runtime(TRAVELING_RUBY_VERSION, "osx-arm64")
    end

    file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-windows-x86_64.tar.gz" do
    # download_runtime(TRAVELING_RUBY_VERSION, "windows-x86_64")
    end
    file "build/traveling-ruby-#{TRAVELING_RUBY_VERSION}-windows-x86.tar.gz" do
    # download_runtime(TRAVELING_RUBY_VERSION, "windows-x86")
    end
    ```

2. Copy your built `traveling-ruby` package into the `build` folder
3. Ensure the version number in `tasks/package.rake` matches your package name
   1. eg
      1. `traveling-ruby-20230508-3.3.9-linux-arm64.tar.gz`

    ```ruby
    TRAVELING_RUBY_VERSION = "20230508-3.3.9"
    ```

4. Run `bundle exec rake package` as before

## Supported Platforms

| OS     | Ruby      | Architecture | Supported |
| -------| ------- | ------------ | --------- |
| OSX    | 3.3.9     | x86_64       | ✅         |
| OSX    | 3.3.9     | aarch64 (arm)| ✅         |
| Linux  | 3.3.9   | x86_64       | ✅         |
| Linux  | 3.3.9   | aarch64 (arm)| ✅          |
| Windows| 3.3.9 | x86_64       | ✅        |
| Windows| 3.3.9 | x86       | ✅        |
| Windows| 3.3.9 | aarch64 (via x86 emulation) |  ✅        |

## Testing

We aim to support testing locally on all platforms, as well as using automated CI scripts.

We suggest avoiding putting logic out of CI workflow yaml files and instead prefer shell files.

We believe it makes testing locally so much easier.

> The workflow files should just contain code that wires the CI platform into your own scripts.

Because of this, you'll find a `script` folder in this repo, with all of the relevant commands.

For the CI runs, check the following

- `./github/workflows` folder for github action jobs
- `.cirrus.yml` workflow for cirrus-ci jobs

Github Actions is used to build, audit, test and push multi-arch images to DockerHub.

Cirrus CI is used to build an arm64 image, and run the integration tests against it.

### Running as the CI system locally

You should be able to run the steps shown in the CI workflows, from your local machine.

- GitHub Actions
  - [Act](https://github.com/nektos/act) (all hosts)

#### Run the test workflow

`act --container-architecture linux/amd64 -W .github/workflows/build.yml --artifact-server-path tmp`