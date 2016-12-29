## README

### Setup
* Configuration:
  - Ruby Version: 2.2.0
  - Database: Postgresql
  - Testing: Rspec
  - Asynchronous Jobs: Sidekiq
   
* run `bundle install`
* Make sure when you start the server you use port 3000 for contests (port 4000 for pets)
  contest results to the pets API `rails s -p 3000`
* Make sure redis is running with `redis-server &`  
* This application uses sidekiq for async processing, start the sidekiq worker with: `bundle exec sidekiq`
* Testing: run tests in terminal with `rake spec`
* run `rake db:seed` to seed your database

### Notes

* Contest creation params: I only pass in a category and pet_ids to create a contest. The evaluation worker
gets the pet's attributes from the Pets API as needed

* Sidekiq Worker: I serialized just the contest_id to the sidekiq worker so
sidekiq would not persist state, just an identifier. This is to prevents the case where
the queue backs up and the contest's state changes unbeknowst to to the worker.

* Polling: I created a status endpoint to return the status of an asynch job. A consumer of
the API could write a function to poll this endpoint. 

* External Posts: Later I would want to have a service that checks if other services are up
and queues messages if they are not. For testing of an external service I would use WebMock
and possibly a fake of the service I am trying to reach to prevent external API requests etc.