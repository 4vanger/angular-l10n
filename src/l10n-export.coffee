module = angular.module('l10n-export', ['l10n'])
resources = {}
rememberValue = (l10n, key, value) ->
	key = key.split(':', 2)[0]
	l10nValue = l10n.get(key)
	setValue = (parent, key, value) ->
		if key.indexOf('.') > 0
			[key, rest] = key.split('.', 2)
			parent[key] = {} unless parent[key]?
			l10n[key] = {} unless l10n[key]?
			setValue(parent[key], rest, value)
		else
			parent[key] = value

	# store all unlocalized values
	if l10nValue == key
		parent = resources
		l10nParent = l10n
		while key.indexOf('.') >= 0
			[key, rest] = key.split('.', 2)
			parent[key] = {} unless parent[key]?
			l10nParent[key] = {} unless l10nParent[key]?
			parent = parent[key]
			l10nParent = l10nParent[key]
			key = rest
		parent[key] = value
		l10nParent[key] = value


angular.forEach ['text', 'html', 'title', 'placeholder', 'href', 'value'], (attr) ->
	directive = 'l10n' + attr.charAt(0).toUpperCase() + attr.substr(1)
	module.directive directive, ['l10n', (l10n) ->
		restrict: 'A'
		priority: 100 # to get element content before it will be replaced
		link: (scope, el, attrs) ->
			value = switch attr
				when 'html' then el.html()
				when 'text' then el.text()
				else el.attr(attr)

			rememberValue(l10n, attrs[directive], value)
	]

module.controller 'L10nExportCtrl', ['$scope', '$filter', 'l10n', (scope, filter, l10n) ->
	scope.currentLocale = l10n.getLocale()
	strings = for string in filter('json')(resources).split('\n')
		string = string.replace(/^\s*/g, (match) -> Array(match.length/2 + 2).join('\t'))
	scope.resources = strings.join('\n')
]
