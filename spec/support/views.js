var ModelWithDesignDocViews = {
  "all": {
    "map": function(doc) {
      emit(doc);
    },
    "reduce": function(doc) {
      emit(doc);
    }
  },
  "strings": {
    "map": function(doc) {
      if (doc.type == "string") emit(doc);
    }
  },
  "four": {
    "map": function(doc) {
      emit(doc);
    },
    "reduce": function(key, values) {
      return 4;
    }
  }
}