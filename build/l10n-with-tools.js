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

(function() {
  var getValue, module;

  getValue = function(scope, l10n, value, setValueFn) {
    var args, l10nValue;

    if (l10n != null) {
      args = value.split(':');
      for(var ii = 1; ii < args.length; ii++){
			try {
				expr = args[ii]
				args[ii] = scope.$eval(expr) || '';
				+function(ii){
					// Update arguments
					scope.$watch(expr, function(val){
						args[ii] = val || '';
						l10nValue = l10n.get.apply(l10n, args);
						if(l10nValue != null){
							value = l10nValue;
						}
						setValueFn(value)
					});
				}(ii)
			} catch (error){
				console.log(error)
				args[ii] = ''
			}
		};
      l10nValue = l10n.get.apply(l10n, args);
      if (l10nValue != null) {
        value = l10nValue;
      }
    }
    return setValueFn(value);
  };

  module = angular.module('l10n-tools', ['l10n']).directive('l10nHtml', [
    'l10n', function(l10n) {
      return {
        restrict: 'A',
        link: function(scope, el, attrs) {
          return getValue(scope, l10n, attrs['l10nHtml'], function(value) {
            return el.html(value);
          });
        }
      };
    }
  ]).directive('l10nText', [
    'l10n', function(l10n) {
      return {
        restrict: 'A',
        link: function(scope, el, attrs) {
          return getValue(scope, l10n, attrs['l10nText'], function(value) {
            return el.text(value);
          });
        }
      };
    }
  ]);

  angular.forEach(['title', 'placeholder', 'href'], function(attr) {
    var directive;

    directive = 'l10n' + attr.charAt(0).toUpperCase() + attr.substr(1);
    return module.directive(directive, [
      'l10n', function(l10n) {
        return {
          restrict: 'A',
          link: function(scope, el, attrs) {
            return getValue(scope, l10n, attrs[directive], function(value) {
              return el.attr(attr, value);
            });
          }
        };
      }
    ]);
  });

}).call(this);
