# Pact Ruby Standalone

![Build](https://github.com/pact-foundation/pact-ruby-standalone/workflows/Build/badge.svg)

Creates a standalone pact command line executable using the ruby pact implementation and Travelling Ruby

## Installation

### Linux and MacOS

    curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/master/install.sh | bash

### Windows


Download and extract from the [release page][releases].

## Usage

Binaries will be extracted into `pact/bin`:

```
./pact/bin/
├── pact
├── pact-broker
├── pactflow
├── pact-message
├── pact-mock-service
├── pact-provider-verifier
├── pact-publish # replaced by `pact-broker publish`
└── pact-stub-service
```

## Supported Platforms

Ruby is not required on the host platform, Ruby 3.2.2 is provided in the distributable.


| OS     | Ruby      | Architecture   | Supported |
| -------| -------   | ------------   | --------- |
| MacOS  | 3.2.2     | x86_64         | ✅        |
| MacOS  | 3.2.2     | aarch64 (arm64)| ✅        |
| Linux  | 3.2.2     | x86_64         | ✅        |
| Linux  | 3.2.2     | aarch64 (arm64)| ✅        |
| Windows| 3.2.2     | x86_64         | ✅        |
| Windows| 3.2.2     | x86            | ✅        |
| Windows| 3.2.2     | aarch64 (arm64)| 🚧        |
