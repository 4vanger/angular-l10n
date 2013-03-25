angular.module('l10n', []).provider('l10n',
	db: {}
	add: (values) ->
		for key, value of values
			# protection against method redefine
			key = '.' + key if key == 'get'
			@db[key] = value
	$get: () ->
		@db.get = (key, substitutions...) ->
			# protection against method redefine
			key = '.' + key if  key == 'get'
			value = @[key]
			return key unless value?

			# expand @referenced values
			while value.charAt(0) == '@' && typeof @[value.substr(1)] != 'undefined'
				value = @[value.substr(1)]

			# if @ symbol is escaped - display it as is
			value = value.substr(1) if value.length >= 2 && value.charAt(0) == '\\' && value.charAt(1) == '@'

			# replace %1, %2 etc with corresponding argument
			`for(var ii = 0; ii < substitutions.length; ii++){
				value = value.replace(new RegExp('%' + (ii + 1) + '([^\\d]|$)', 'g'), substitutions[ii]+ '$1')
			}`

			value

		@db
)
