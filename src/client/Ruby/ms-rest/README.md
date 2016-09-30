# Intro

MsRest is a library which supports the clients (SDKs) generated with Autorest tool. It contains core logic and helper classes for error handling and authentication. Usually it is not supposed to be used as a standalone gem but only as a dependency for generated client gems.

# Supported Ruby Versions

* Ruby 1.9.3
* Ruby 2.0
* Ruby 2.1
* Ruby 2.2

Note: x64 Ruby for Windows is known to have some compatibility issues.

# Installation

install the appropriate gem:

```
gem install ms_rest
```

and reference it in your code:

```Ruby
require 'ms_rest'
```
---
If you encounter `Faraday::SSLError` like below 
```Ruby
Faraday::SSLError:
            SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
```
that implies that ruby's OpenSSL was unable to verify the peer certificate while establihsing an SSL connection. You can provide Faraday ssl options or opt-in to use already bundled certificate using
```Ruby
MsRest.use_ssl_cert
```
---

# Running tests

MsRest has only unit tests which doesn't require any preparation, just run 'rspec' command from the gem directory.

# Contribution

To start working on the gem the only additional dev dependecy is required - rspec. After you've added a new feature and all specs pass - you're good to go with PR. But before starting any bug/feature - please make sure you've thoroughly discussed it with repository maintainers. This gem already powers a few SDKs and backward compatibility should taken in account.

# Adding gem to you generated SDK

Reference it in the gemfile and also add this line to your client's gemspec file:

```ruby
spec.add_runtime_dependency 'ms_rest', '~> 0.5.0'
```

Don't forget to correct the version.

# Provide feedback

Send email to the azsdkteam@microsoft.com or file new issue in this repository.
