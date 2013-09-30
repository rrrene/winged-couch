window.WingedCouch or= {}

WingedCouch.Utils =
  buildUrlFromPath: (prefix, path) ->
    url = "#{prefix}/#{path}"
    while matchdata = url.match(/[^:]\/\//)
      match = matchdata[0]
      url = url.replace(match, "#{match[0]}/")
    url