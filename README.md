# Flex Time

A scheduling application for flex time periods in K-12 schools.

[![Build Status](https://travis-ci.com/osu-cascades/flex-time.svg?token=UcyKnDFJfk4eb8TzWbtd&branch=master)](https://travis-ci.com/osu-cascades/flex-time) [![Test Coverage](https://api.codeclimate.com/v1/badges/158ce0907b3c88aa9baa/test_coverage)](https://codeclimate.com/github/osu-cascades/flex-time/test_coverage)

## Prerequisites

Please use Ruby 2.7.4 and Rails 5.2.6+. You'll need a PostgreSQL server running.

## Development

Clone the repository, `bundle install`, create a _.env_ based on _.env.example_, create the database, and run the server.

```
bundle install
rails db:create
rails server
```

## Test

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

At the time of this writing, the tests are specific to Tuesday, Thursday, Friday days.
This is a smell.

## Domain / Work System Notes

A User is anyone who may sign in to the system. There are three roles: admin,
staff, and student (the default). Admins have full control. Staff can modify everything
except for users. Students can choose their activities and see their own weekly
schedules.

A Teacher is a concept separate from a User who is a teacher (staff role). A Teacher
represents the main flextime period teacher. For flex time periods, students usually
have a period teacher or home room teacher. They then go to particular activities
held by specific people in the school.

Activities are specific activities that students may participate in.

A Registration represents a student's "signup" for a particular Activity.

### The way it all works

After a new deployment, we invite the principal to sign in to the system, and we
then elevate their role to _admin_. The principal can then create Teacher records
in the system.

Next, the principal invites staff to sign up. Right now, anyone can sign up in the
system as long as their email domain is allowed. **[smell: security]** The principal
then elevates these staff User roles to _staff_.

Staff and admins then create lists of activities for particular days of the week.
The days of the week are driven by configuration (env vars) as different schools
hold their flex time periods on different days of the week.

For a new school year, staff then invite students to sign in for the first time.
This authenticates the students via Google, and creates a new User record with
the _student_ role in our system. Students are then prompted to select their
flex time teacher prior to being able to register for an activity. They may then
select an activity for each flex time period up to one week in advance. They have
until a 'cutoff' time to sign up for a particular day. The cutoff time is driven
by configuration (env vars) as different schools hold their flex time period at
different times of the day. We also assume that the time is the same for each day
of the week.

Between school years, some students graduate and leave the school. To prepare
for a new school year, the admin resets all student rosters, which disassociates
students from teachers. Next, the admin uses the Users interface to manually
deactivate the students who have left the school. In addition, when staff Users leave the school, the admin sets their User record as inactive. Deactivated users may not sign in to the system.

Sometimes, to speed up user deactivation, we obtan a list of email addresses, and
run a script on the server to deactivate all the users with those email addresses.


&copy; 2017 Yong Bakos. All rights reserved.
