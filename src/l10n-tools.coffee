module = angular.module('l10n-tools', ['l10n'])
	.directive('l10nHtml',['l10n', (l10n) ->
		restrict: 'A'
		link: (scope, el, attrs) ->
			value = attrs['l10nHtml']
			# try to localize value is localization service is available
			value = l10n.get(value) if l10n?
			el.html value
	])
	.directive('l10nText', ['l10n', (l10n) ->
		restrict: 'A'
		link: (scope, el, attrs) ->
			value = attrs['l10nText']
			# try to localize value is localization service is available
			value = l10n.get(value) if l10n?
			el.text value
	])

angular.forEach ['title', 'placeholder', 'href'], (attr) ->
	directive = 'l10n' + attr.charAt(0).toUpperCase() + attr.substr(1)
	module.directive directive, ['l10n', (l10n) ->
		restrict: 'A'
		link: (scope, el, attrs) ->
			value = attrs[directive]
			# try to localize value is localization service is available
			value = l10n.get(value) if l10n?
			console.log(attr, value)
			el.attr(attr, value)
	]
