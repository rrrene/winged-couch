# TODO

+ Implement ability to use global common database for specified model
Like this
``` ruby
  class MyModel < WingedCouch::Model
    use_global_database

    attribute :name, String
    # ...
  end
```

+ Implement more validation functions (currently we have only `exist`)