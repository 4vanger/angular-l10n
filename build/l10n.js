(function() {
  var __slice = [].slice;

  angular.module('l10n', []).provider('l10n', {
    db: {},
    add: function(values) {
      var key, value, _results;

      _results = [];
      for (key in values) {
        value = values[key];
        if (key === 'get') {
          key = '.' + key;
        }
        _results.push(this.db[key] = value);
      }
      return _results;
    },
    $get: function() {
      this.db.get = function() {
        var index, key, substitutions, value, _i, _ref;

        key = arguments[0], substitutions = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        if (key === 'get') {
          key = '.' + key;
        }
        value = this[key];
        if (value == null) {
          return key;
        }
        while (value.charAt(0) === '@') {
          value = this[value.substr(1)];
        }
        if (value.length >= 2 && value.charAt(0) === '\\' && value.charAt(1) === '@') {
          value = value.substr(1);
        }
        for (index = _i = 1, _ref = substitutions.length; 1 <= _ref ? _i <= _ref : _i >= _ref; index = 1 <= _ref ? ++_i : --_i) {
          value.replace(new RegExp('%' + index, 'g'), substitutions[index - 1]);
        }
        return value;
      };
      return this.db;
    }
  });

}).call(this);
