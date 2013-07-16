# TODO

+ Configuration module

``` ruby
# Example only
CouchORM.setup do |config|
  config.host = "http://host.com"
  config.port = 1234
  # some other options ...
end
```

+ CouchOrm model

``` ruby
# Example only
class SomeModel < CouchORM::Model
  # your code goes here
end
```