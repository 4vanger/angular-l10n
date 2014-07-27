angular.module('l10n', ['ngLocale'])
.provider('l10n',
	db: {}
	locale: null
	localeMessages: {}
	# transform messages using function. Must return object with messages
	transform: null
	add: (localeCode, values) ->
		values = @transform(localeCode, values) if @transform
		# protection against method redefine
		for key in values
			if angular.isFunction @db[method]
				values['$' + key] = values[key]
				delete values[key]

		@localeMessages[localeCode] = {} if typeof @localeMessages[localeCode] == 'undefined'
		angular.extend @localeMessages[localeCode], values

	setLocale: (localeCode) ->
		# remember preferred locale
		@locale = localeCode
		# clean up DB first
		for key of @db
			delete @db[key] unless angular.isFunction @db[key]
		angular.extend(@db, @localeMessages[localeCode])

	$get: ['$rootScope', '$locale', (rootScope, locale) ->
		# change locale to desired one
		locale.id = @locale if @locale
		@setLocale(locale.id)
		
		@db.getAllLocales = => return @localeMessages
		@db.setLocale = (localeCode) =>
			locale.id = localeCode
			@setLocale(localeCode)
			rootScope.$broadcast('l10n-locale', localeCode)

		@db.getLocale = => locale.id

		@db.get = (key, substitutions...) ->
			return '' unless key
			originalKey = key
			# protection against method redefine
			key = '$' + key if angular.isFunction @[key]
			parent = @
			# get value from hash
			while (pos = key.indexOf('.')) > 0
				rest = key.substr(pos + 1)
				key = key.substr(0, pos)

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
