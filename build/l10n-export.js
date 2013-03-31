(function() {
  var module, rememberValue, resources;

  module = angular.module('l10n-export', ['l10n']);

  resources = {};

  rememberValue = function(l10n, key, value) {
    var l10nParent, l10nValue, parent, rest, setValue, _ref;

    key = key.split(':', 2)[0];
    l10nValue = l10n.get(key);
    setValue = function(parent, key, value) {
      var rest, _ref;

      if (key.indexOf('.') > 0) {
        _ref = key.split('.', 2), key = _ref[0], rest = _ref[1];
        if (parent[key] == null) {
          parent[key] = {};
        }
        if (l10n[key] == null) {
          l10n[key] = {};
        }
        return setValue(parent[key], rest, value);
      } else {
        return parent[key] = value;
      }
    };
    if (l10nValue === key) {
      parent = resources;
      l10nParent = l10n;
      while (key.indexOf('.') >= 0) {
        _ref = key.split('.', 2), key = _ref[0], rest = _ref[1];
        if (parent[key] == null) {
          parent[key] = {};
        }
        if (l10nParent[key] == null) {
          l10nParent[key] = {};
        }
        parent = parent[key];
        l10nParent = l10nParent[key];
        key = rest;
      }
      parent[key] = value;
      return l10nParent[key] = value;
    }
  };

  angular.forEach(['text', 'html', 'title', 'placeholder', 'href', 'value'], function(attr) {
    var directive;

    directive = 'l10n' + attr.charAt(0).toUpperCase() + attr.substr(1);
    return module.directive(directive, [
      'l10n', function(l10n) {
        return {
          restrict: 'A',
          priority: 100,
          link: function(scope, el, attrs) {
            var value;

            value = (function() {
              switch (attr) {
                case 'html':
                  return el.html();
                case 'text':
                  return el.text();
                default:
                  return el.attr(attr);
              }
            })();
            return rememberValue(l10n, attrs[directive], value);
          }
        };
      }
    ]);
  });

  module.controller('L10nExportCtrl', [
    '$scope', '$filter', 'l10n', function(scope, filter, l10n) {
      var string, strings;

      scope.currentLocale = l10n.getLocale();
      strings = (function() {
        var _i, _len, _ref, _results;

        _ref = filter('json')(resources).split('\n');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          string = _ref[_i];
          _results.push(string = string.replace(/^\s*/g, function(match) {
            return Array(match.length / 2 + 2).join('\t');
          }));
        }
        return _results;
      })();
      return scope.resources = strings.join('\n');
    }
  ]);

}).call(this);
