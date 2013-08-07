var stringifyObject = function(obj) {
  var result = {};
  if (typeof(obj) === 'function') {
    return obj.toString();
  } else if (typeof(obj) == 'object') {
    for (var key in obj) {
      result[key] = stringifyObject(obj[key]);
    }
    return result;
  } else{
    return obj;
  }
}