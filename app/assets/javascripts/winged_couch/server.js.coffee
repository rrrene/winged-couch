window.WingedCouch or= {}

WingedCouch.Server =
  get: (path, data = {}) ->
    deferred = $.Deferred()
    url = WingedCouch.Utils.buildUrlFromPath(@serverPrefix(), path)

    request = $.getJSON(url, data)
    request.done(@callback deferred).fail(@errback deferred)

    deferred.promise()

  serverPrefix: ->
    WingedCouch.Configuration.host

  callback: (deferred) ->
    (data) ->
      deferred.resolve(data)

  errback: (deferred) ->
    ->
      deferred.reject()