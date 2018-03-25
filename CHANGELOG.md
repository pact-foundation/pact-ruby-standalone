<a name="v1.33.1"></a>
### v1.33.1 (2018-03-26)


#### Features

* set default external encoding to UTF-8   ([f3db394](/../../commit/f3db394))

* **gems**
  * update to pact-message 0.2.1	 ([f3db394](/../../commit/f3db394))


<a name="v1.33.0"></a>
### v1.33.0 (2018-03-25)


#### Features

* **gems**
  * update non-pact gems	 ([7199ab5](/../../commit/7199ab5))

* **pact-message**
  * add pact-message binary to release	 ([1feec03](/../../commit/1feec03))


<a name="v1.32.0"></a>
### v1.32.0 (2018-03-24)


#### Features

* **gems**
  * update to pact-provider-verifier 1.12.0	 ([1fa854e](/../../commit/1fa854e))


<a name="v1.31.0"></a>
### v1.31.0 (2018-03-24)


#### Features

* **gems**
  * update to pact-support 1.5.2, pact 1.22.2	 ([073e1d2](/../../commit/073e1d2))


<a name="v1.30.1"></a>
### v1.30.1 (2018-03-19)


#### Features

* **gems**
  * update to pact-support 1.3.1	 ([5f9a7d7](/../../commit/5f9a7d7))


<a name="v1.30.0"></a>
### v1.30.0 (2018-03-19)


#### Features

* **gems**
  * update to pact-support 1.3.0, pact 1.21.0	 ([fd18941](/../../commit/fd18941))

* set PACT_EXECUTING_LANGUAGE to 'unknown' when not set by wrapper language	 ([5f1aa62](/../../commit/5f1aa62))
* add linux support to install.sh - beware! Not yet tested.	 ([92f10d7](/../../commit/92f10d7))
* create basic install script	 ([7b48fbe](/../../commit/7b48fbe))


<a name="v1.29.2"></a>
### v1.29.2 (2018-02-22)


#### Features

* **gems**
  * update to pact-mock_service 2.6.4	 ([7ababbe](/../../commit/7ababbe))


<a name="v1.29.1"></a>
### v1.29.1 (2018-02-16)


#### Features

* **gems**
  * update to pact-support 1.2.5	 ([d89dfec](/../../commit/d89dfec))


<a name="v1.29.0"></a>
### v1.29.0 (2018-02-16)


#### Bug Fixes

* ensure RUBYGEMS_GEMDEPS is unset for all scripts	 ([d1f3656](/../../commit/d1f3656))
* set BUNDLE_FROZEN=1 to stop bundler attempting to modify Gemfile.lock	 ([67c216e](/../../commit/67c216e))


<a name="v1.28.0"></a>
### v1.28.0 (2018-02-08)


#### Features

* **gems**
  * update non-pact gems	 ([2ed8cff](/../../commit/2ed8cff))

* **pact-provider-verifier cli**
  * allow custom certificates to be used by setting SSL_CERT_FILE and SSL_CERT_DIR	 ([5cbcce1](/../../commit/5cbcce1))


<a name="v1.27.0"></a>
### v1.27.0 (2018-02-08)


#### Features

* **pact-broker cli**
  * allow custom certificates to be used by setting SSL_CERT_FILE and SSL_CERT_DIR	 ([08e5420](/../../commit/08e5420))


<a name="v1.26.0"></a>
### v1.26.0 (2018-02-05)


#### Features

* **gems**
  * update to pact 1.20.1	 ([dea151f](/../../commit/dea151f))


<a name="v1.25.0"></a>
### v1.25.0 (2018-02-03)


#### Features

* **gems**
  * update non-pact gems	 ([60f075e](/../../commit/60f075e))

* remove extraneous .rb in help text	 ([1080344](/../../commit/1080344))
* add pact docs to standalone package	 ([9ed1d30](/../../commit/9ed1d30))


<a name="v1.24.0"></a>
### v1.24.0 (2018-01-25)


#### Features

* lock webrick to ~>1.3.1	 ([60b840e](/../../commit/60b840e))


<a name="v1.23.0"></a>
### v1.23.0 (2018-01-25)


#### Features

* **gems**
  * update to pact_broker-client 1.14.0	 ([8d88df8](/../../commit/8d88df8))

* add can-i-deploy usage to README	 ([99bf770](/../../commit/99bf770))


#### Bug Fixes

* quote $LIBDIR in shell scripts so that spaces are handled correctly	 ([c591d36](/../../commit/c591d36))


<a name="v1.22.1"></a>
### v1.22.1 (2017-12-18)


#### Features

* **gems**
  * update to pact-mock_service 2.6.3	 ([406e2f3](/../../commit/406e2f3))


<a name="v1.22.0"></a>
### v1.22.0 (2017-12-10)


#### Features

* **gems**
  * update to pact 1.20.0	 ([d20bd1e](/../../commit/d20bd1e))


<a name="v1.21.0"></a>
### v1.21.0 (2017-12-07)


#### Features

* **gems**
  * update to pact_broker-client 1.13.1, pact-mock_service 2.6.2, pact 1.19.2, pact-provider-verifier 1.11.0	 ([b4c855d](/../../commit/b4c855d))


<a name="v1.20.0"></a>
### v1.20.0 (2017-11-09)


#### Features

* **gems**
  * update to pact_broker-client 1.13.0	 ([db52238](/../../commit/db52238))


<a name="v1.19.0"></a>
### v1.19.0 (2017-11-07)


#### Features

* **gems**
  * update to pact-mock_service 2.6.0, pact-provider-verifier 1.9.0	 ([7ffe0b0](/../../commit/7ffe0b0))


<a name="v1.17.1"></a>
### v1.17.1 (2017-11-07)

#### Bug Fixes

* issue with linux removing quotes from arguments  ([a387e23](/../../commit/a387e23))

<a name="v1.17.0"></a>
### v1.17.0 (2017-11-06)


#### Features

* **gems**
  * update to pact_broker-client 1.12.0	 ([ed103ff](/../../commit/ed103ff))


<a name="v1.16.0"></a>
### v1.16.0 (2017-11-01)


#### Features

* **gems**
  * update to pact_broker-client 1.11.0, pact 1.19.1	 ([197ead3](/../../commit/197ead3))


<a name="v1.15.0"></a>
### v1.15.0 (2017-10-31)


#### Features

* **gems**
  * update to pact_broker-client 1.10.0, pact 1.19.0	 ([e3eb8d6](/../../commit/e3eb8d6))


<a name="v1.14.0"></a>
### v1.14.0 (2017-10-30)

#### Features

* **gems**
  * update to pact_broker-client 1.9.0	 ([58bb0ea](/../../commit/58bb0ea))


<a name="v1.13.0"></a>
### v1.13.0 (2017-10-30)

#### Features

* **gems**
  * update to pact-support 1.2.4, pact-mock_service 2.5.4, pact 1.18.0	 ([5a8cb24](/../../commit/5a8cb24))
  * update to pact-mock_service 2.5.1	 ([1b0ed8b](/../../commit/1b0ed8b))

<a name="v1.12.0"></a>
### v1.12.0 (2017-10-27)

#### Features

* **gems**
  * update pact to 1.17.0, pact-provider-verifier to 1.8.0, pact-support to 1.2.2	 ([9b052ec](/../../commit/9b052ec))

<a name="v1.11.0"></a>
### v1.11.0 (2017-10-19)

#### Features

* **gems**
  * upgrade pact_broker-client to 1.8.0	 ([f4eb23a](/../../commit/f4eb23a))

#### BREAKING CHANGES

* Moved `pact-publish` to `pact-broker publish` ([f4eb23a](/../../commit/f4eb23a))

<a name="v1.10.0"></a>
### v1.10.0 (2017-10-19)

#### Features

* **gems**
  * update pact_broker-client to 1.7.0 and pact-provider-verifier to 1.7.0	 ([40bb5c1](/../../commit/40bb5c1))

<a name="v1.9.1"></a>
### v1.9.1 (2017-10-18)

#### Features

* **gems**
  * update pact to 1.16.1	 ([3dc94d6](/../../commit/3dc94d6))

<a name="v1.9.0"></a>
### v1.9.0 (2017-10-13)

#### Features

* add pact-stub-service to standalone package	 ([b5a65f0](/../../commit/b5a65f0))

* **gems**
  * update pact-mock_service to 2.4.0	 ([03cf5a8](/../../commit/03cf5a8))

<a name="v1.8.0"></a>
### v1.8.0 (2017-10-04)

#### Features

* **gems**
  * update pact-support to 1.2.0, pact-mock_service to 2.3.0, pact-provider-verifier to 1.6.0	 ([abc3606](/../../commit/abc3606))

<a name="v1.7.1"></a>
### v1.7.1 (2017-10-02)

#### Bug Fixes

* correct pact-provider-verifier require	 ([2510b54](/../../commit/2510b54))

<a name="v1.7.0"></a>
### v1.7.0 (2017-10-01)

#### Features

* **readme**
  * add detailed usage notes generated from each tool	 ([97a60f9](/../../commit/97a60f9))

* **gems**
  * update pact-provider-verifier to 1.5.0 and pact_broker-client to 1.6.0	 ([3f5b1a2](/../../commit/3f5b1a2))

<a name="v1.6.0"></a>
### v1.6.0 (2017-09-30)

#### Features

* **gems**
  * update pact-mock_service to 2.2.0	 ([bab09c8](/../../commit/bab09c8))

<a name="v1.5.0"></a>
### v1.5.0 (2017-09-30)

#### Features

* **pact publish**
  * add pact-publish cli	 ([9f760a3](/../../commit/9f760a3))

<a name="v1.4.4"></a>
### v1.4.4 (2017-08-27)

#### Features

* **gems**
  * update pact-provider-verifier to 1.4.1	 ([5e10e07](/../../commit/5e10e07))

<a name="v1.4.3"></a>
### v1.4.3 (2017-08-25)

#### Features

* **gems**
  * update pact-support to 1.1.6	 ([17f0b3e](/../../commit/17f0b3e))

<a name="v1.4.0"></a>
### v1.4.0 (2017-08-11)

#### Features

* **gems**
  * update pact to 1.15.0 and pact-provider-verifier to 1.4.0	 ([8a39a47](/../../commit/8a39a47))

<a name="v1.3.1"></a>
### v1.3.0 (2017-08-08)
#### Features

* **gems**
  * Update pact-provider-verifier to 1.3.1	 ([36cb12a](/../../commit/36cb12a))

<a name="v1.2.2"></a>
## 1.2.2 (5 Aug 2017)
* 427ed71 - chore(reduce package size): Remove supposedly unnecessary native extension sources and compilation objects. Last time we tried this, something broke on windows, but now we have the pact-ruby-standalone-windows-test to help identify the problem. (Beth Skurrie, Sat Aug 5 17:31:23 2017 +1000)
* d6809a4 - chore(reduce package size): Remove unnecessary encoding files (Beth Skurrie, Sat Aug 5 17:30:17 2017 +1000)

## 1.2.1 (5 Aug 2017)
* dc35c77 - chore(reduce package size): Remove unnecessary files from package (Beth Skurrie, Sat Aug 5 17:00:41 2017 +1000)

## 1.2.0 (3 Aug 2017)
* f02ee8a - chore(gems): Updated pact-provider-proxy to 2.2.0 (Beth Skurrie, Thu Aug 3 14:47:21 2017 +1000)

## 1.1.2 (1 Aug 2017)
* 8c3ca90 - chore(gems): Updated pact-support gem to 1.1.5 (Beth Skurrie, Tue Aug 1 10:43:07 2017 +1000)

## 1.1.2-alpha.1 (28 July 2017)
* f3d0584 - chore(gems): Updated pact-mock_service to 2.1.1.pre.alpha.2 (Beth Skurrie, Fri Jul 28 16:41:17 2017 +1000)

## 1.1.1 (19 June 2017)
* 8f77fda - chore(gems): Update pact-support to 1.1.3 (Beth Skurrie, Fri Jul 28 09:48:43 2017 +1000)

## 1.0.0 (19 June 2017)
* a8b6cc4 - Updated pact-support to 1.1.2 (Beth Skurrie, Fri Jun 23 14:51:04 2017 +1000)

## 1.0.0 (19 June 2017)
* 2c5fe56 - Updating pact-mock_service to 2.1.0, pact-support to 1.1.0, pact to 1.14.0 (Beth Skurrie, Mon Jun 19 10:09:02 2017 +1000)
