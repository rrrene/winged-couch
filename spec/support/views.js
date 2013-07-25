var ModelWithDesignDocViews = {
  "all": {
    "map": function(doc) {
      emit(doc._id);
    },
    "reduce": function(doc) {
      emit(123);
    }
  },
  "strings": {
    "map": function(doc) {
      if (doc.type == "string") emit(doc);
    }
  }
}