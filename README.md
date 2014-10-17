httpd-monitoring
================
httpd-monitoring is a simple console program that monitors HTTP traffic by parsing an actively written-to w3c-formatted HTTP access log.

It displays every 10s a short report showing most hit sections, most active ips, and total traffic.

It triggers an alarm when last 2min hits are above a threshold (arg given in command line).

## Installation

Use [Bundler](http://bundler.io) to install it.

Just run `bundle`. It will install everything needed.

You should then be able to directly use `httpd-monitoring` command.

## Usage

Launch in a console :

```bash
httpd-monitoring -l LIMIT path-to-log-file
```

LIMIT being the alert threshold.

It will then display a report every 10s, and alerts/recovers when threshold is crossed.

## Tests

Tests can be launched using `rake`:
- `rake syntax`: check Ruby for bad syntax practices thanks to [Rubocop](https://github.com/bbatsov/rubocop),
- `rake spec`: run [Rspec](http://rspec.info) tests,
- `rake short_test`: run a short test on httpd-monitoring, writing a log file and writing `httpd-monitoring` output to console, (use spec/test_log)
- `rake long_test`: run a long test on httpd-monitoring to test alert management, (use spec/test_log)
- `rake`: runs `syntax`, `spec` and `long_test`.

It is tested on Travis : [![Build Status](https://travis-ci.org/degemer/httpd-monitoring.svg?branch=master)](https://travis-ci.org/degemer/httpd-monitoring)

## Compatibility

OS:
- Linux: tested on Debian 7.
- Windows: not working, gem `eventmachine-tail` needs `eventmachine` method `watch_file`, not working on Windows.
- Mac: not tested. It should not have the same issue than Windows.

Ruby >= 1.9.3 (tested with 1.9.3, 2.0.0, 2.1.3).

## Improvements

- Alerts and recovers are only tested when something is written to the log file. If there is an alert going on, and then no traffic, alert will not be recovered until something is written. Could be solved by adding a periodic callback to check if alert is recovered.
- Alarm class should be called after data is inserted, and not insert data itself. (also related to previous improvement)
- HTTP code are not analyzed now ; they could be, and could be added to the report (non-ok codes associated with number of hits).
- Windows compatibility might be obtained by using [em-dir-watcher](https://github.com/mockko/em-dir-watcher).
- Add an option to remove colors from output to be able to redirect a neutral ` httpd-monitoring` output to a file. (without having strange characters in file)
