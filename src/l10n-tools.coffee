getValue = (scope, l10n, value, setValueFn) ->
	if l10n?
		args = value.split(':')

		`for(var ii = 1; ii < args.length; ii++){
			try {
				var expr = args[ii]
				args[ii] = scope.$eval(expr) || '';
				// create closure to protect index value
				+function(ii){
					// when expression changes - recalculate message
					scope.$watch(expr, function(val){
						// update arguments list
						args[ii] = val || '';
						l10nValue = l10n.get.apply(l10n, args);
						if(l10nValue != null){
							value = l10nValue;
						}
						setValueFn(value)
					});
				}(ii)
			} catch (error){
				args[ii] = ''
			}
		}`

		l10nValue = l10n.get.apply(l10n, args)
		value = l10nValue if l10nValue?
	setValueFn value

module = angular.module('l10n-tools', ['l10n'])
	.directive('l10nHtml',['l10n', (l10n) ->
		restrict: 'A'
		link: (scope, el, attrs) ->
			getValue scope, l10n, attrs['l10nHtml'], (value) ->
				el.html value
	])
	.directive('l10nText', ['l10n', (l10n) ->
		restrict: 'A'
		link: (scope, el, attrs) ->
			getValue scope, l10n, attrs['l10nText'], (value) ->
				el.text value
	])

angular.forEach ['title', 'placeholder', 'href'], (attr) ->
	directive = 'l10n' + attr.charAt(0).toUpperCase() + attr.substr(1)
	module.directive directive, ['l10n', (l10n) ->
		restrict: 'A'
		link: (scope, el, attrs) ->
			getValue scope, l10n, attrs[directive], (value) ->
				el.attr attr, value
	]
