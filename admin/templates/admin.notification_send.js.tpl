$('#inputDestinatari').tagsinput({
  tagClass: function(item) {
    switch (item.type) {
      case 'user'    : return 'label label-tag';
      case 'program' : return 'label label-success';
    }
  },
  itemValue: 'value',
  itemText: 'text',
  typeahead: {
    displayKey: 'text',
    source: $tags
  },
  allowDuplicates: false,
  freeInput: false
});