describe 'L10n provider', ->
	provider = null
	beforeEach ->
		angular.module('test-provider', ['l10n']).config (l10nProvider) -> provider = l10nProvider
		module 'test-provider'
		inject ->
	afterEach ->
		# cleanup
		provider.localeMessages = {}
		provider.db = {}

	it 'should exist', ->
		expect(provider).toBeDefined()
	it 'should have empty message DB initially', ->
		expect(provider.localeMessages).toEqual {}
		expect(provider.db).toEqual {}
	it 'should be able to add locale messages', ->
		provider.add 'uk-UA', key: 'message'
		expect(provider.localeMessages).toEqual 'uk-UA': {key: 'message'}
		expect(provider.db).toEqual {}
		provider.add 'en-US', key: 'message'
		expect(provider.localeMessages).toEqual
			'uk-UA': {key: 'message'}
			'en-US': {key: 'message'}
	it 'should extend locale messages when locale is added multiple times', ->
		provider.add 'en-US', key: 'message'
		provider.add 'en-US', key2: 'message2'
		expect(provider.localeMessages).toEqual
			'en-US': {key: 'message', key2: 'message2'}
	it 'should transform input using "transform"', ->
		provider.transform = (locale, values) ->
			values[key] = '!!!' + value for key, value of values
			return values
		provider.add 'uk-UA', key: 'message'
		expect(provider.localeMessages).toEqual 'uk-UA': {key: '!!!message'}
		provider.transform = null
