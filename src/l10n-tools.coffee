getValue = (scope, l10n, value, setValueFn) ->
	args = value.split(':')

	setValue = ->
		l10nValue = l10n.get.apply(l10n, args);
		if(l10nValue != null)
			value = l10nValue
		setValueFn(value)

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
					setValue();
				});
			}(ii)
		} catch (error){
			args[ii] = ''
		}
	}`
	scope.$on('l10n-locale', setValue)
	setValue()

module = angular.module('l10n-tools', ['l10n'])
angular.forEach ['text', 'html', 'title', 'placeholder', 'href', 'value'], (attr) ->
	directive = 'l10n' + attr.charAt(0).toUpperCase() + attr.substr(1)
	module.directive directive, ['l10n', (l10n) ->
		restrict: 'A'
		priority: 90
		link: (scope, el, attrs) ->
			switch attr
				when 'html ' then fn = (value) -> el.html value
				when 'text' then fn = (value) -> el.text value
				else fn = fn = (value) -> el.attr attr, value

			getValue scope, l10n, attrs[directive], fn
	]

module.filter 'l10n', ['l10n', (l10n) ->
	(key, subs...) ->
		l10n.get.apply(l10n, arguments)
]
