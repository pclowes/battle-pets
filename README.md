# battle-pets
Simple app to explore service architectures

* This app consists of "Pets" and "Contests" APIs they are under the battle-pets directory to make
pulling from github require just one repo instead of two.

* Setup instructions and notes for each API is in their respective README's
* There is a demo.rb script in this directory that shows the communication between
the two APIs. Make sure the two APIs are fully set up with the Pets API running on
port 4000 and the Contests API running on port 3000 before running. Also be sure
 that sidekiq has started to handle async processing.
