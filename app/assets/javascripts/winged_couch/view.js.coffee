class WingedCouch.View
  constructor: (@model, @name) ->
    @params = {}

  with: (key, value) ->
    @params[key] = value

  path: ->
    "/#{@model.dbName}/_design/winged_couch/_view/#{@name}"

  perform: (options = {}) ->
    deferred = $.Deferred()
    WingedCouch.Server.
      get(@path(), @params).
      done(@callback deferred).
      fail(@errback deferred)

    deferred

  callback: (deferred) ->
    model = @model
    (data) ->
      result = data.rows.map (attrs) =>
        model.from(attrs.value)
      deferred.resolve(result)

  errback: (deferred) ->
    ->
      deferred.reject()