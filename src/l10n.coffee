angular.module('l10n', []).provider('l10n',
	db: {}
	add: (values) ->
		for key, value of values
			# protection against method redefine
			key = '.' + key if key == 'get'
			@db[key] = value
	$get: () ->
#		console.log($ParseProvider)
		@db.get = (key, substitutions...) ->
			# protection against method redefine
			key = '.' + key if  key == 'get'
			value = @[key]
			return key unless value?
			# expand @referenced values
			value = @[value.substr(1)] while value.charAt(0) == '@'
			value = value.substr(1) if value.length >= 2 && value.charAt(0) == '\\' and value.charAt(1) == '@'

			# replace %1, %2 etc with corresponding argument
			for index in [1..substitutions.length]
				value.replace(new RegExp('%' + index, 'g'), substitutions[index - 1])

			value

		@db
)
