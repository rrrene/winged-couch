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
  "by_name": {
    "map": function(doc) {
      if (doc.name) {
        emit(doc.name, doc);
      }
    }
  },
  "four": {
    "map": function(doc) {
      emit(doc);
    },
    "reduce": function(key, values) {
      return 4;
    }
  },
  "key_objects": {
    "map": function(doc) {
      emit(doc, doc.name.length);
    },
    "reduce": function(key, values) {
      return sum(values);
    }
  }
}