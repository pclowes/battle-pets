## README

### Setup
* Configuration:
  - Ruby Version: 2.2.0
  - Database: Postgresql
  - Testing: Rspec
   
* run `bundle install`
* Make sure when you start the server you use a port other than 3000 as that is hardcoded when posting
  contest results to the pets API
* Testing: run tests in terminal with `rake spec`
* run `rake db:seed` to seed your database

### Notes

* Contest creation params: I pass up the entire pet objects as contestants as I envision them being
selected through a UI and sent off to a contest. Could also just send the contests API pet ids
and have it get the necessary attributes from the pets API.

* Sidekiq Worker: I serialized just the contest_id to the sidekiq worker so
sidekiq would not persist state, just an identifier. This is to prevents the case where
the queue backs up and the contest's state changes unbeknowst to to the worker.

* Polling: I created a status endpoint to return the status of an asynch job. A consumer of
the API could write a function to poll this endpoint. If I knew more about who
would want to receive these messages I could build a push service or implement a publish
subscribe pattern to decrease network call volume.

* External Posts: Later I would want to have a service that checks if other services are up
and queues messages if they are not. For robust testing of an external service I would use WebMock
and possibly a fake of the service I am trying to reach to prevent external API requests etc.