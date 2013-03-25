angular.module('l10n', []).provider('l10n',
	db: {}
	add: (values) ->
		if typeof values['get'] != 'undefined'
			# protection against method redefine
			values.$get = values.get
			delete values.get
		angular.extend @db, values
	$get: () ->
		@db.get = (key, substitutions...) ->
			originalKey = key
			# protection against method redefine
			key = '$' + key if  key == 'get'
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
)
