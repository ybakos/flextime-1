# Flex Time

A scheduling application for flex time periods in K-12 schools.

[![Build Status](https://travis-ci.com/osu-cascades/flex-time.svg?token=UcyKnDFJfk4eb8TzWbtd&branch=master)](https://travis-ci.com/osu-cascades/flex-time) [![Test Coverage](https://api.codeclimate.com/v1/badges/158ce0907b3c88aa9baa/test_coverage)](https://codeclimate.com/github/osu-cascades/flex-time/test_coverage)

# Prerequisites

Please use Ruby 2.6.5 and Rails 5.2.1+. You'll need a PostgreSQL server running.

# Development

Clone the repository, `bundle install`, create a _.env_ based on _.env.example_, create the database, and run the server.

```
bundle install
rails db:create
rails server
```

# Test

Test with the Rails built-in test harness.

```
rails test
```

Or

```
guard
```

The test suite exercises model, helper, controllers and system tests.
It currently uses the built-in fixtures mechanism.

At the time of this writing, the tests are specific to Tuesday, Thursday Friday days. This is a smell.

&copy; 2017 Yong Bakos. All rights reserved.
