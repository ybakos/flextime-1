# Falcon Time

A scheduling application for Falcon Time at [Sky View Middle School](https://www.bend.k12.or.us/skyview).

[![Build Status](https://travis-ci.org/osu-cascades/falcon-time.svg?branch=master)](https://travis-ci.org/osu-cascades/falcon-time) [![Test Coverage](https://api.codeclimate.com/v1/badges/158ce0907b3c88aa9baa/test_coverage)](https://codeclimate.com/github/osu-cascades/falcon-time/test_coverage)

# Prerequisites

Please use Ruby 2.4.2 and Rails 5.1.4+. You'll need a Postresql server running.

# Development

Clone the repository, `bundle install`, optionally create a _.env_ from _.env.example_, create the database, and run the server.

```
bundle install
rails db:create
rails server
```


&copy; 2017 Yong Bakos. All rights reserved.
