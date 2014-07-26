describe 'provider', ->
	provider = null
	beforeEach ->
		angular.module('test-app', ['l10n']).config (l10nProvider) -> provider = l10nProvider
		module 'test-app'
		inject ->
	afterEach ->
		# cleanup
		provider.localeMessages = {}
		provider.db = {}

	it 'Provider found', ->
		expect(provider).toBeDefined()
	it 'Message DB is empty first', ->
		expect(provider.localeMessages).toEqual {}
		expect(provider.db).toEqual {}
	it 'Adding locale messages', ->
		provider.add 'uk-UA', key: 'message'
		expect(provider.localeMessages).toEqual 'uk-UA': {key: 'message'}
		expect(provider.db).toEqual {}
		provider.add 'en-US', key: 'message'
		expect(provider.localeMessages).toEqual
			'uk-UA': {key: 'message'}
			'en-US': {key: 'message'}
	it 'Adding same locale multiple times extends messages array', ->
		provider.add 'en-US', key: 'message'
		provider.add 'en-US', key2: 'message2'
		expect(provider.localeMessages).toEqual
			'en-US': {key: 'message', key2: 'message2'}
	it 'transforming input using "transform"', ->
		provider.transform = (locale, values) ->
			values[key] = '!!!' + value for key, value of values
			return values
		provider.add 'uk-UA', key: 'message'
		expect(provider.localeMessages).toEqual 'uk-UA': {key: '!!!message'}
