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

### Natives Gems

Natives gems are not build on windows, so you get an error if you try to do this

```ps1
PS Y:\pkg> .\pact-cli\lib\ruby\bin\ruby -r'pact/ffi' -e true
Ignoring ffi-1.15.5 because its extensions are not built. Try: gem pristine ffi --version 1.15.5
<internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:85:in `require': cannot load such file -- ffi_c (LoadError)
        from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from Y:/pkg/pact-cli/lib/ruby/lib/ruby/gems/3.2.0/gems/ffi-1.15.5/lib/ffi.rb:5:in `rescue in <top (required)>'
        from Y:/pkg/pact-cli/lib/ruby/lib/ruby/gems/3.2.0/gems/ffi-1.15.5/lib/ffi.rb:2:in `<top (required)>'
        from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:85:in `require'             from Y:/pkg/pact-cli/lib/ruby/lib/ruby/gems/3.2.0/gems/pact-ffi-0.0.2-x64-mingw-ucrt/lib/pact/ffi.rb:2:in `<top (required)>'                                                                                                                    from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:159:in `require'            from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:159:in `rescue in require'
        from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:39:in `require'
<internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:85:in `require': cannot load such file -- 3.2/ffi_c (LoadError)
Did you mean?  3.2.0/devkit
        from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from Y:/pkg/pact-cli/lib/ruby/lib/ruby/gems/3.2.0/gems/ffi-1.15.5/lib/ffi.rb:3:in `<top (required)>'
        from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from Y:/pkg/pact-cli/lib/ruby/lib/ruby/gems/3.2.0/gems/pact-ffi-0.0.2-x64-mingw-ucrt/lib/pact/ffi.rb:2:in `<top (required)>'
        from <internal:Y:/pkg/pact-cli/lib/ruby/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:159:in `require'

```

If we try to install ffi inside the windows package.


```ps1
PS Y:\pkg> .\pact-cli\lib\ruby\bin\gem install ffi
Ignoring ffi-1.15.5 because its extensions are not built. Try: gem pristine ffi --version 1.15.5
Fetching ffi-1.15.5.gem
MSYS2 could not be found. Please run 'ridk install'
or download and install MSYS2 manually from https://msys2.github.io/
```

## Package sizes

#### Full Ruby Bundle - with pact-plugin-cli

As per todays release.

    49M    pkg/pact

    16M    pkg/pact-2.0.2-linux-arm64.tar.gz
    16M    pkg/pact-2.0.2-linux-x86_64.tar.gz
    14M    pkg/pact-2.0.2-osx-arm64.tar.gz
    15M    pkg/pact-2.0.2-osx-x86_64.tar.gz
    11M    pkg/pact-2.0.2-windows-x86.zip
    16M    pkg/pact-2.0.2-windows-x86_64.zip

#### Full Ruby (only) Bundle

    37M    pkg/pact

    12M    pkg/pact-2.0.2-windows-x86_64.zip
    12M    pkg/pact-2.0.2-windows-x86.zip
    10M    pkg/pact-2.0.2-osx-x86_64.tar.gz
    10M    pkg/pact-2.0.2-linux-x86_64.tar.gz
    9.0M   pkg/pact-2.0.2-osx-arm64.tar.gz
    9.0M   pkg/pact-2.0.2-linux-arm64.tar.gz

#### Trimmed Ruby (only) Bundle

TRIM_PACKAGE_FULL=true bundle exec rake package

    28M    pkg/pact

    10M    pact-2.0.2-windows-x86.zip
    9.7M   pact-2.0.2-windows-x86_64.zip
    7.0M   pact-2.0.2-linux-arm64.tar.gz
    7.0M   pact-2.0.2-linux-x86_64.tar.gz
    7.0M   pact-2.0.2-osx-arm64.tar.gz
    7.0M   pact-2.0.2-osx-x86_64.tar.gz

#### Full Ruby Bundle + Pact Rust Tools

`PACKAGE_PACT_RUST_TOOLS=true bundle exec rake package`

    98M    pkg/pact

    41M    pkg/pact-2.0.2-linux-x86_64.tar.gz
    39M    pkg/pact-2.0.2-linux-arm64.tar.gz
    34M    pkg/pact-2.0.2-osx-x86_64.tar.gz
    33M    pkg/pact-2.0.2-osx-arm64.tar.gz
    33M    pkg/pact-2.0.2-windows-x86_64.zip
    11M    pkg/pact-2.0.2-windows-x86.zip

    du -sh pkg/pact/bin/* | sort -nr

    18M    pkg/pact/bin/pact_verifier_cli
    17M    pkg/pact/bin/pact_mock_server_cli
    14M    pkg/pact/bin/pact-stub-server
    12M    pkg/pact/bin/pact-plugin-cli

#### Ruby (only) + Pact-Ffi Gem (and pact_ffi libs) Bundle 

`PACKAGE_PACT_FFI=true bundle exec rake package`

    64M    pkg/pact

    21M    pkg/pact-2.0.2-windows-x86_64.zip
    21M    pkg/pact-2.0.2-windows-x86.zip
    19M    pkg/pact-2.0.2-osx-x86_64.tar.gz
    19M    pkg/pact-2.0.2-osx-arm64.tar.gz
    19M    pkg/pact-2.0.2-linux-x86_64.tar.gz
    19M    pkg/pact-2.0.2-linux-arm64.tar.gz

    24M    pkg/pact/lib/vendor/ruby/3.2.0/gems/pact-ffi-0.0.2-arm64-darwin/ffi/macos-arm64/libpact_ffi.dylib

#### Full Ruby Bundle + Pact Rust Tools + Pact-Ffi Gem (and pact_ffi libs)

`PACKAGE_PACT_RUST_TOOLS=true PACKAGE_PACT_FFI=true bundle exec rake package`

    123M    pkg/pact-cli
    52M    pkg/pact-cli-2.0.2-linux-x86_64.tar.gz
    51M    pkg/pact-cli-2.0.2-linux-arm64.tar.gz
    43M    pkg/pact-cli-2.0.2-osx-x86_64.tar.gz
    41M    pkg/pact-cli-2.0.2-osx-arm64.tar.gz
    33M    pkg/pact-cli-2.0.2-windows-x86_64.zip
    12M    pkg/pact-cli-2.0.2-windows-x86.zip
    24M    pkg/pact/lib/vendor/ruby/3.2.0/gems/pact-ffi-0.0.2-arm64-darwin/ffi/macos-arm64/libpact_ffi.dylib




### Building & Testing.

You can easily run through the testing by passing the same env vars.

The following scenario will

- package the pact-ruby-standalone for osx:arm64
- include the rust tools
- include the pact ffi
- unpack the built package that would be distributed to users
- runs a smoke test against the package

`PACKAGE_PACT_RUST_TOOLS=true PACKAGE_PACT_FFI=true bundle exec rake package:osx:arm64`

`PACKAGE_PACT_RUST_TOOLS=true PACKAGE_PACT_FFI=true PACKAGE_NAME=pact-cli ./script/unpack-and-test.sh`

You can run the smoke tests anyway, your standalone directory lives.

- Run the script `/script/test.sh`
- Set your env vars
  - `PATH_TO_BIN=pkg/pact-cli/bin/` default is `$PACKAGE_NAME/bin/
    - `ensure it has a trailing /`
    - if windows, reverse the slashes `\`
  - `PACKAGE_NAME` default is `pact`

Example scenario

- runs a smoke test against the package
  - includes tests for the rust tools
  - includes test for the pact ffi

`PACKAGE_PACT_RUST_TOOLS=true PACKAGE_PACT_FFI=true PACKAGE_NAME=pact-cli PATH_TO_BIN=pkg/pact-cli/bin/ ./script/test.sh`