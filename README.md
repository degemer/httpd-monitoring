httpd-monitoring
================
httpd-monitoring is a simple console program that monitors HTTP traffic by parsing an actively written-to w3c-formatted HTTP access log.

It displays every 10s a short report showing most hit sections, most active ips, and total traffic.

It triggers an alarm when last 2min hits are above a threshold (arg given in command line).

## Installation

Use [Bundler](http://bundler.io) to install it.

Just run `bundle`. It will install everythin needed.

You should then be able to directly use `httpd-monitoring` command.

## Usage

Launch in a console :

```bash
httpd-monitoring -l LIMIT path-to-log-file
```

LIMIT being the alert threshold.

## Tests

Tests can be launched using `rake`:
- `rake syntax`: check Ruby for bad syntax practices,
- `rake spec`: run [Rspec](http://rspec.info) tests,
- `rake short_test`: run a short test on httpd-monitoring, writing a log file and writing `httpd-monitoring` output to console,
- `rake long_test`: run a long test on httpd-monitoring to test alert management,
- `rake`: runs `syntax`, `spec` and `long_test`.

It is tested on Travis : [![Build Status]https://travis-ci.org/degemer/httpd-monitoring.svg?branch=master)](https://travis-ci.org/degemer/httpd-monitoring)

## Compatibility

OS:
- Linux: tested on debian 7.
- Windows: not working, gem `eventmachine-tail` needs `eventmachine` method `watch_file`, not working on Windows.
- Mac: not tested.

Ruby versions: fully compatible with 1.9.3, 2.0.0, 2.1.3 (see tests on [Travis](https://travis-ci.org/degemer/httpd-monitoring)).

## Improvements
