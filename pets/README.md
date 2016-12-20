## README

### Setup
* Configuration:
  - Ruby Version: 2.2.0
  - Database: Postgresql
  - Testing: Rspec
  
* run `bundle install`
* Make sure when you start the server you use port 3000 as that is hardcoded in the Contests api
  (In a real application this would obviously not be the case)
* Testing: run tests in terminal with `rake spec`
* run `rake db:seed` to seed your database

### Notes

* Pets Controller: just has the bare endpoints required for the challenge. Could have a GET
  endpoint so that the Contests API can get contestants from the Pets API by id instead of
  receiving the contestants with the contest creation.
  
* Result Service: although a very small service, I didn't want to have business logic of any
  kind in the controller

