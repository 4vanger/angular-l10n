(function() {
  var __slice = [].slice;

  angular.module('l10n', []).provider('l10n', {
    db: {},
    add: function(values) {
      if (typeof values['get'] !== 'undefined') {
        values.$get = values.get;
        delete values.get;
      }
      return angular.extend(this.db, values);
    },
    $get: function() {
      this.db.get = function() {
        var key, newValue, originalKey, parent, rest, substitutions, value, _ref;

        key = arguments[0], substitutions = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        originalKey = key;
        if (key === 'get') {
          key = '$' + key;
        }
        parent = this;
        while (key.indexOf('.') > 0) {
          _ref = key.split('.', 2), key = _ref[0], rest = _ref[1];
          if (typeof parent[key] !== 'undefined') {
            parent = parent[key];
          } else {
            return originalKey;
          }
          key = rest;
        }
        value = parent[key];
        if (value == null) {
          return originalKey;
        }
        while (value.charAt(0) === '@') {
          newValue = this.get(value.substr(1));
          if (typeof newValue !== 'undefined') {
            value = newValue;
          }
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
