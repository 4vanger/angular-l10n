angular.module('l10n', []).provider('l10n',
	db: {}
	localeMessages: {}
	locale: null
	add: (locale, values) ->
		# protection against method redefine
		for key in values
			if angular.isFunction @db[method]
				values['$' + key] = values[key]
				delete values[key]

		@localeMessages[locale] = {} if typeof @localeMessages[locale] == 'undefined'
		angular.extend @localeMessages[locale], values
		@setLocale(locale) unless locale

	setLocale: (locale) ->
		# clean up DB first
		for key, value of @db
			delete @db[key] unless angular.isFunction @db[key]
		@locale = locale
		angular.extend(@db, @localeMessages[@locale])

	$get: ['$rootScope', (rootScope) ->
		@db.setLocale = (locale) =>
			@setLocale(locale)
			rootScope.$broadcast('l10n-locale', locale)

		@db.getLocale = =>
			@locale

		@db.get = (key, substitutions...) ->
			originalKey = key
			# protection against method redefine
			key = '$' + key if angular.isFunction @[key]
			parent = @
			# get value from hash
			while key.indexOf('.') > 0
				[key, rest] = key.split('.', 2)
				if typeof parent[key] != 'undefined'
					parent = parent[key]
				else
					return originalKey
				key = rest
			value = parent[key]
			return originalKey unless value?

			if typeof value == 'string'
				# expand @referenced values
				while value.charAt(0) == '@'
					newValue = @.get(value.substr(1))
					value = newValue unless typeof newValue == 'undefined'

				# if @ symbol is escaped - display it as is
				value = value.substr(1) if value.length >= 2 && value.charAt(0) == '\\' && value.charAt(1) == '@'

				# replace %1, %2 etc with corresponding argument
				`for(var ii = 0; ii < substitutions.length; ii++){
					value = value.replace(new RegExp('%' + (ii + 1) + '([^\\d]|$)', 'g'), substitutions[ii]+ '$1')
				}`

			value

		@db
	]
)
