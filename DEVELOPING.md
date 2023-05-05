## Packaging

pact-ruby-standalone is packaged with `traveling-ruby`

### Building the `traveling-ruby` runtime

1. Build the traveling ruby runtime
   1. `git clone xyz`

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
    bash -c 'mkdir -p cache output/3.2.2'
    bash -c './build-ruby -a x86 -r 3.2.2 cache output/3.2.2'
    bash -c './package -r traveling-ruby-20230428-3.2.2-x86-windows.tar.gz output/3.2.2'

For windows x86

    bash -c 'mkdir -p cache output/3.2.2'
    bash -c './build-ruby -a x86_64 -r 3.2.2 cache output/3.2.2'
    bash -c './package -r traveling-ruby-20230428-3.2.2-x86_64-windows.tar.gz output/3.2.2'

### Building the pact-ruby-standalone packages

The following steps are the same, whether you are using the published traveling-ruby binaries, or you have built your own

Setup your gems

    bundle install

Build all the pact-ruby-standalone packages

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
      1. `traveling-ruby-20230508-3.2.2-linux-arm64.tar.gz`

    ```ruby
    TRAVELING_RUBY_VERSION = "20230508-3.2.2"
    ```

4. Run `bundle exec rake package` as before

## Supported Platforms

| OS     | Ruby      | Architecture | Supported |
| -------| ------- | ------------ | --------- |
| OSX    | 3.2.2     | x86_64       | ✅         |
| OSX    | 3.2.2     | aarch64 (arm)| ✅         |
| Linux  | 3.2.2   | x86_64       | ✅         |
| Linux  | 3.2.2   | aarch64 (arm)| ✅          |
| Windows| 3.2.2 | x86_64       | ✅        |
| Windows| 3.2.2 | x86       | ✅        |
| Windows| 3.2.2 | aarch64 (via x86 emulation) |  ✅        |

## Testing

We aim to support testing locally on all platforms, as well as using automated CI scripts.

We suggest avoiding putting logic out of CI workflow yaml files and instead prefer shell files.

We believe it makes testing locally so much easier.

> The workflow files should just contain code that wires the CI platform into your own scripts.

Because of this, you should find a `script` or `scripts` folder in the repo, with all the relevant commands, see other pact-foundation repos, if you are unsure.

For your particular repo, check the following

- `./github/workflows` folder for github action jobs
- `.cirrus.yml` workflow for cirrus-ci jobs

### Tested Platforms

- Windows
- MacOS
- Linux

### Tested Architectures

- x86_64 / x64
- arm64 / aarch64

### CI Systems

We utilize a combination of

- GitHub Actions
  - Windows x86_64
  - MacOS x86_64
  - Linux x86_64 / amd64
- Cirrus-CI
  - MacOS arm64
  - MacOS x86_64 emulation via Rosetta
  - Linux arm64
  - Linux x86_64 / amd64

### CI Testing Table

This is a CI testing table for `pact-ruby-standalone` - You should aim to try and cover as many as possible.

| OS     | Standalone Version     | Architecture | Tested |
| -------| ------- | ------------ | --------- |
| OSX    | v2.0.0     | x86_64       | GitHub Actions            |
| OSX    | v2.0.0     | aarch64 (arm)| Cirrus CI         |
| Linux  | v2.0.0  | x86_64       | GitHub Actions          |
| Linux  | v2.0.0  | aarch64 (arm)| Cirrus-CI       |
| Windows| v2.0.0 | x86_64       | GitHub Actions        |
| Windows| v2.0.0 | x86       | Untested        |
| Windows| v2.0.0 | aarch64 (via x86 emulation) |  Untested       |

### Running as the CI system locally

You should be able to run the steps shown in the CI workflows, from your local machine, however there are some additional options available to you

> "Think globally, act locally"

There are a couple of ways, you can act as the CI system locally.

- GitHub Actions
  - [Act](https://github.com/nektos/act) (all hosts)
- Cirrus-CI
  - [Cirrus-cli](https://github.com/cirruslabs/cirrus-cli) (all hosts)
  - [Tart.run](https://github.com/cirruslabs/tart/) (macOS hosts)

These will provide you the ability to run the following combinations.

| OS     | CI System        | Architecture  | Tool  | Notes |
| Linux  | GitHub Actions   | x86_64        | act   | requires docker |
| Linux  | Cirrus CI        | x86_64        | cirrus-cli   | requires docker or podman and x86_64 host |
| Linux  | Cirrus CI        | aarch64       | cirrus-cli    | requires docker or podman and aarch64 host |
| macOS  | Cirrus CI        | aarch64       | cirrus-cli / tart.run   | requires MacOS arm64 (M1/M2) host, can test with or without rosetta |

#### Act notes

In any repo with a `.github/workflows/*.yml` file in, you can run

##### Running all the tasks

`act`

##### Reporters

Reporting is pretty good out the box, if a little noisy, especially when running multi-matrix ubuntu tasks

##### Running a single workflow

`act -W .github/workflows/x-plat.yml`

##### Running a single job

`act -W --job build_linux`

##### Passing in custom env vars

##### Passing in secrets

`act -s DOCKER_HUB_USERNAME=pactfoundation -s DOCKER_HUB_TOKEN=i<3Pact`

##### Using docker-compose inside a workflow

The base act image, doesn't have docker-compose in it, you can install it conditionally, using this [action](https://github.com/KengoTODA/actions-setup-docker-compose) 

    ```yaml
        - uses: KengoTODA/actions-setup-docker-compose@v1
            if: ${{ env.ACT }}
            name: Install `docker-compose` for use with https://github.com/nektos/act
            with:
            version: '2.15.1'
    ```

##### Gotchas

1. non `x86_64` / `amd64` hosts will need to pass the `--container-architecture linux/amd64` flag when running `act`
2. sometimes you get zombie containers that need killing.
3. not everything works, so sometimes it justs worth pushing the code to CI

#### Cirrus CLI notes

See https://github.com/cirruslabs/cirrus-cli for instructions on how to download the tool

_Note:_ Cirrus CLI only supports Linux container and macos_instance VMs at the moment.

In any repo with a `.cirrus.yml` file in, you can run

##### Running all the tasks

`cirrus run`

##### Reporters

By default, you are shown `stdout` but it is swallowed as each step passes. I would recommend using the `--output github-actions` command

`cirrus run --output github-actions`

##### Running a single task

`cirrus run "linux_arm64" --output github-actions`

##### Passing in custom env vars

`cirrus run "builder_ruby_source_linux" --output github-actions -e CIRRUS_CHANGE_TITLE="ci(cirrus): builder_ruby_source_linux"`

##### Load a dockerfile as an environment

_Note:_ Linux runners support the Dockerfile as a CI environment feature.

 https://cirrus-ci.org/guide/docker-builder-vm/#dockerfile-as-a-ci-environme

    ```yaml
        alpine_arm64_task: 
            arm_container:
                dockerfile: Dockerfile.alpine.arm64
                <<: *DOCKER_ARGS_ARM64_TEMPLATE
            <<: *TEST_TASK_TEMPLATE
    ```

##### Placeholders / Templating

We want to avoid repeating ourselves in our scripts, so we can use templates. Based on the `dockerfile` as an environment scenario above.

This allows us to reuse our tasks across cirrus-ci, and ideally run the same scripts in both GitHub Actions and Cirrus-CI, remembering our golden rule

> The workflow files should just contain code that wires the CI platform into your own scripts.

        ```yaml
        env:
        PACT_VERSION: 2.0.0

        TEST_TASK_TEMPLATE: &TEST_TASK_TEMPLATE
        test_script: uname -a && pact-mock-service --help

        DOCKER_ARGS_ARM64_TEMPLATE: &DOCKER_ARGS_ARM64_TEMPLATE
            docker_arguments:
            PACT_VERSION: $PACT_VERSION
            TARGET_ARCH: arm64

        DOCKER_ARGS_X64_TEMPLATE: &DOCKER_ARGS_X64_TEMPLATE
            docker_arguments:
            PACT_VERSION: $PACT_VERSION
            TARGET_ARCH: x86_64
        ```

##### Gotchas

1. cirrus cli ignores the `arm_container` task, and expects `container` which are setup in cirrus-ci to become `amd64`/`x86_64` hosts.
   1. If you change `arm_container` to `container`, you can run the task on a macOS arm64 host, but the docker default platform will be `arm64`/`aarch64` which means you might not get the results you are expecting.
   2. There are settings to configure, but these don't appear to work for me, or I haven't found the right combo yet.
      1. `CIRRUS_ARCH` as an `env` var (https://cirrus-ci.org/guide/docker-builder-vm/#docker-builder-vm)
      2. `architecture` as a `container` property (https://cirrus-ci.org/guide/docker-builder-vm/#under-the-hood)
2. You'll need at least 50gb to 100gb to run macOS instance tests locally, as they pull down a ventura virtual machine
3. If you get stuck on the steps for CI, you can boot a virtual macOS or linux machine, perform all the steps you need, test them out, then script them up