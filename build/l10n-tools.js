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
