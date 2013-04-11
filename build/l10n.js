(function() {
  var __slice = [].slice;

  angular.module('l10n', ['ngLocale']).provider('l10n', {
    db: {},
    localeMessages: {},
    add: function(localeCode, values) {
      var key, _i, _len;

      for (_i = 0, _len = values.length; _i < _len; _i++) {
        key = values[_i];
        if (angular.isFunction(this.db[method])) {
          values['$' + key] = values[key];
          delete values[key];
        }
      }
      if (typeof this.localeMessages[localeCode] === 'undefined') {
        this.localeMessages[localeCode] = {};
      }
      return angular.extend(this.localeMessages[localeCode], values);
    },
    setLocale: function(localeCode) {
      var key;

      for (key in this.db) {
        if (!angular.isFunction(this.db[key])) {
          delete this.db[key];
        }
      }
      return angular.extend(this.db, this.localeMessages[localeCode]);
    },
    $get: [
      '$rootScope', '$locale', function(rootScope, locale) {
        var _this = this;

        console.log(this.setLocale);
        this.setLocale(locale.id);
        this.db.setLocale = function(localeCode) {
          locale.id = localeCode;
          _this.setLocale(localeCode);
          return rootScope.$broadcast('l10n-locale', localeCode);
        };
        this.db.getLocale = function() {
          return locale.id;
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
