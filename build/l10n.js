(function() {
  var __slice = [].slice;

  angular.module('l10n', []).provider('l10n', {
    db: {},
    localeMessages: {},
    locale: null,
    add: function(locale, values) {
      var key, _i, _len;

      for (_i = 0, _len = values.length; _i < _len; _i++) {
        key = values[_i];
        if (angular.isFunction(this.db[method])) {
          values['$' + key] = values[key];
          delete values[key];
        }
      }
      if (typeof this.localeMessages[locale] === 'undefined') {
        this.localeMessages[locale] = {};
      }
      angular.extend(this.localeMessages[locale], values);
      if (locale) {
        return this.setLocale(locale);
      }
    },
    setLocale: function(locale) {
      var key, value, _ref;

      _ref = this.db;
      for (key in _ref) {
        value = _ref[key];
        if (!angular.isFunction(this.db[key])) {
          delete this.db[key];
        }
      }
      this.locale = locale;
      return angular.extend(this.db, this.localeMessages[this.locale]);
    },
    $get: [
      '$rootScope', function(rootScope) {
        var _this = this;

        this.db.setLocale = function(locale) {
          _this.setLocale(locale);
          return rootScope.$broadcast('l10n-locale', locale);
        };
        this.db.getLocale = function() {
          return _this.locale;
        };
        this.db.get = function() {
          var key, newValue, originalKey, parent, pos, rest, substitutions, value;

          key = arguments[0], substitutions = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
          originalKey = key;
          if (angular.isFunction(this[key])) {
            key = '$' + key;
          }
          parent = this;
          while ((pos = key.indexOf('.')) > 0) {
            rest = key.substr(pos + 1);
            key = key.substr(0, pos);
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
          if (typeof value === 'string') {
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
          }
          return value;
        };
        return this.db;
      }
    ]
  });

}).call(this);
