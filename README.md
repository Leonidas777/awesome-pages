#README - Awesome Pages


## Ruby version

**Ruby 2.0.0**



## Setup instructions

Copy ruby versions manager config files
```
cp .ruby-gemset.template .ruby-gemset
cp .ruby-version.template .ruby-version
```

Reload ruby versions manager

Copy database config
```
cp config/database.yml.template config/database.yml
```

Add to config/database.yml username and password from PostgreSQL

Install gems
```
bundle install
```

Setup database 
```
rake db:setup
```

Start rails server 
```
rails s puma
```



## How to run the test suite

```bash
bundle exec rspec spec
```


## How to run the application

```bash
bundle exec rails s
```
