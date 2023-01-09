# Pact Ruby Standalone

![Build](https://github.com/pact-foundation/pact-ruby-standalone/workflows/Build/badge.svg)
 [![Build status](https://ci.appveyor.com/api/projects/status/32ci5o2kikr46kg9?svg=true)](https://ci.appveyor.com/project/MichelBoudreau/pact-ruby-standalone-windows-test)

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

[releases]: https://github.com/pact-foundation/pact-ruby-standalone/releases
