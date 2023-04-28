# Pact Ruby Standalone

![Build](https://github.com/pact-foundation/pact-ruby-standalone/workflows/Build/badge.svg)

Creates a standalone pact command line executable using the ruby pact implementation and Travelling Ruby

## Installation

See the [releases](https://github.com/pact-foundation/pact-ruby-standalone/releases) page for installation instructions.

## Usage

Download the appropriate package for your operating system from the [releases](https://github.com/pact-foundation/pact-ruby-standalone/releases) page and unzip it.

    $ cd pact/bin
    $ ./pact-mock-service --help start
    $ ./pact-provider-verifier --help verify

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
