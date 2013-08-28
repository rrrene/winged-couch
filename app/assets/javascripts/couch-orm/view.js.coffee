class CouchORM.View
  constructor: (@name, @model) ->
    @params = {}
    @database = @model.database()

  addParam: (key, value) ->
    @params[key] = value

  http_method: ->
    @params.http_method || "get"

  couchdb_call: (uri, callback) ->
    @database[@http_method()](uri, callback)

  uri: ->
    "_design/couch_orm/_view/#{@name}"

  perform: (options, callback) ->
    callback = options unless callback
    throw("No callback passed") unless typeof(callback) == "function"
    @couchdb_call @uri(), (data) =>
      if options.raw
        callback(data)
      else
        callback(@transformed(data))

  transformed: (data) ->
    result = []
    for attrs in data.rows
      result.push(@model.from(attrs.value))
    result