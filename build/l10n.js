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
        var key, substitutions, value;

        key = arguments[0], substitutions = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        if (key === 'get') {
          key = '.' + key;
        }
        value = this[key];
        if (value == null) {
          return key;
        }
        while (value.charAt(0) === '@' && typeof this[value.substr(1)] !== 'undefined') {
          value = this[value.substr(1)];
        }
        if (value.length >= 2 && value.charAt(0) === '\\' && value.charAt(1) === '@') {
          value = value.substr(1);
        }
        for(var ii = 0; ii < substitutions.length; ii++){
				value = value.replace(new RegExp('%' + (ii + 1) + '([^\\d]|$)', 'g'), substitutions[ii]+ '$1')
			};
        return value;
      };
      return this.db;
    }
  });

}).call(this);
