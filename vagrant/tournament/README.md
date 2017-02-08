##Swiss Pairing Tournament
* provides database and basic functions for a swiss pairing tournament

###Files
- tournament.py
- tournament.sql
- tournament_test.py

###To run
* need to have vagrant, vbox, postgresql installed
* navigate to /vagrant/tournament and start up psql
```
vagrant@vagrant-ubuntu-trusty-32:/vagrant/tournament$ psql
```
* drop tournament databases if already exists:
```
vagrant=> drop database if exists tournament;
```
* create databases and tables:
```
vagrant=> \i tournament.sql
```
* to test, in /vagrant/tournament run:
```
vagrant@vagrant-ubuntu-trusty-32:/vagrant/tournament$ python tournament_test.py
```
