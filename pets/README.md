## README

### Setup
* Configuration:
  - Ruby Version: 2.2.0
  - Database: Postgresql
  - Testing: Rspec
  
* run `bundle install`
* Make sure when you start the server you use port 4000 (3000 for contests) `rails s -p 4000`
  (In a real application this would obviously not be the case)
* Testing: run tests in terminal with `rake spec`
* run `rake db:seed` to seed your database

### Notes

* Pets Controller: endpoints to create, get, and post contest results to pets.
  
* Result Service: although a very small service, I didn't want to have business logic of any
  kind in the controller

