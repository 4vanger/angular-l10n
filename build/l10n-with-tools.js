(function() {
  var __slice = [].slice;

  angular.module('l10n', ['ngLocale']).provider('l10n', {
    db: {},
    localeMessages: {},
    transform: null,
    add: function(localeCode, values) {
      var key, _i, _len;
      if (this.transform) {
        values = this.transform(localeCode, values);
      }
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
        this.setLocale(locale.id);
        this.db.getAllLocales = function() {
          return _this.localeMessages;
        };
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
          if (!key) {
            return '';
          }
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

(function() {
  var getValue, module,
    __slice = [].slice;

  getValue = function(scope, l10n, value, setValueFn) {
    var args, setValue;
    if (!value) {
      return value;
    }
    args = value.split(':');
    setValue = function() {
      var l10nValue;
      l10nValue = l10n.get.apply(l10n, args);
      if (l10nValue !== null) {
        value = l10nValue;
      }
      return setValueFn(value);
    };
    for(var ii = 1; ii < args.length; ii++){
		try {
			var expr = args[ii]
			args[ii] = scope.$eval(expr) || '';
			// create closure to protect index value
			+function(ii){
				// when expression changes - recalculate message
				scope.$watch(expr, function(val){
					// update arguments list
					args[ii] = val || '';
					setValue();
				});
			}(ii)
		} catch (error){
			args[ii] = ''
		}
	};
    scope.$on('l10n-locale', setValue);
    return setValue();
  };

  module = angular.module('l10n-tools', ['l10n']);

  angular.forEach(['text', 'html', 'title', 'placeholder', 'href', 'value'], function(attr) {
    var directive;
    directive = 'l10n' + attr.charAt(0).toUpperCase() + attr.substr(1);
    return module.directive(directive, [
      'l10n', '$interpolate', function(l10n, interpolate) {
        return {
          restrict: 'A',
          priority: 90,
          link: function(scope, el, attrs) {
            var fn;
            switch (attr) {
              case 'html':
                fn = function(value) {
                  return el.html(value);
                };
                break;
              case 'text':
                fn = function(value) {
                  return el.text(value);
                };
                break;
              default:
                fn = fn = function(value) {
                  return el.attr(attr, value);
                };
            }
            return attrs.$observe(directive, function() {
              return getValue(scope, l10n, attrs[directive], fn);
            });
          }
        };
      }
    ]);
  });

  module.filter('l10n', [
    'l10n', function(l10n) {
      return function() {
        var key, subs;
        key = arguments[0], subs = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        return l10n.get.apply(l10n, arguments);
      };
    }
  ]);

}).call(this);
