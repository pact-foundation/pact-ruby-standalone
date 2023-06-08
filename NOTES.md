## Windows on ARM

### using x86_64 package

Error

```ps1
PS Y:\pkg> .\pact\bin\pact.bat
unexpected ucrtbase.dll
```

To resolve - Use x86 package.

Tested on

```console
[System.Environment]::OSVersion.Version

Major  Minor  Build  Revision
-----  -----  -----  --------
10     0      22621  0
```

### Package sizes

#### Full Ruby Bundle - with pact-plugin-cli

16M    pkg/pact-2.0.2-linux-arm64.tar.gz
16M    pkg/pact-2.0.2-linux-x86_64.tar.gz
14M    pkg/pact-2.0.2-osx-arm64.tar.gz
15M    pkg/pact-2.0.2-osx-x86_64.tar.gz
11M    pkg/pact-2.0.2-windows-x86.zip
16M    pkg/pact-2.0.2-windows-x86_64.zip

unpacked on osx arm64 = 49mb

#### Full Ruby (only) Bundle

9.0M    pkg/pact-2.0.2-linux-arm64.tar.gz
 10M    pkg/pact-2.0.2-linux-x86_64.tar.gz
9.0M    pkg/pact-2.0.2-osx-arm64.tar.gz
 10M    pkg/pact-2.0.2-osx-x86_64.tar.gz
 11M    pkg/pact-2.0.2-windows-x86.zip
 12M    pkg/pact-2.0.2-windows-x86_64.zip

unpacked on osx arm64 = 37mb

#### Trimmed Ruby (only) Bundle

7.0M    pact-2.0.2-linux-arm64.tar.gz
7.0M    pact-2.0.2-linux-x86_64.tar.gz
7.0M    pact-2.0.2-osx-arm64.tar.gz
7.0M    pact-2.0.2-osx-x86_64.tar.gz
 10M    pact-2.0.2-windows-x86.zip
9.7M    pact-2.0.2-windows-x86_64.zip

unpacked on osx arm64 = 28mb


#### Full Ruby Bundle + Pact Rust Tools

98M    pkg/pact
39M    pkg/pact-2.0.2-linux-arm64.tar.gz
41M    pkg/pact-2.0.2-linux-x86_64.tar.gz
33M    pkg/pact-2.0.2-osx-arm64.tar.gz
34M    pkg/pact-2.0.2-osx-x86_64.tar.gz
11M    pkg/pact-2.0.2-windows-x86.zip
33M    pkg/pact-2.0.2-windows-x86_64.zip

du -sh pkg/pact/bin/* | sort -nr

 18M    pkg/pact/bin/pact_verifier_cli
 17M    pkg/pact/bin/pact_mock_server_cli
 14M    pkg/pact/bin/pact-stub-server
 12M    pkg/pact/bin/pact-plugin-cli

#### Ruby (only) + Pact-Ffi Gem (and pact_ffi libs) Bundle 


#### Full Ruby Bundle + Pact Rust Tools + Pact-Ffi Gem (and pact_ffi libs)