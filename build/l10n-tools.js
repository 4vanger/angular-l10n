(function() {
  var module;

  module = angular.module('l10n-tools', ['l10n']).directive('l10nHtml', [
    'l10n', function(l10n) {
      return {
        restrict: 'A',
        link: function(scope, el, attrs) {
          var value;

          value = attrs['l10nHtml'];
          if (l10n != null) {
            value = l10n.get(value);
          }
          return el.html(value);
        }
      };
    }
  ]).directive('l10nText', [
    'l10n', function(l10n) {
      return {
        restrict: 'A',
        link: function(scope, el, attrs) {
          var value;

          value = attrs['l10nText'];
          if (l10n != null) {
            value = l10n.get(value);
          }
          return el.text(value);
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
            var value;

            value = attrs[directive];
            if (l10n != null) {
              value = l10n.get(value);
            }
            return el.attr(attr, value);
          }
        };
      }
    ]);
  });

}).call(this);
