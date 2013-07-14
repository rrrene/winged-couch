# TODO

+ HTTP module (for communication with CouchDB)

``` ruby
# Example only
CouchORM::HTTP.get(url, query: {})
# => { :some => "response" }
CouchORM::HTTP.post(url, body: {}) do |response|
  puts response
end
# => { :another => "response" }
CouchORM::HTTP.put(url, body: {})
CouchORM::HTTP.delete(url)
```

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