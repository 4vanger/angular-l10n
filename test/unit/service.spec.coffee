describe "service", ->
	provider = null
	service = null
	beforeEach ->
		angular.module('test-app', ['l10n']).config (l10nProvider) ->
			provider = l10nProvider
			provider.add 'en-US',

		module 'test-app'
	afterEach ->
		# cleanup
		provider.locale = null
		provider.localeMessages = {}
		provider.db = {}

	it "by default locale is en-us (angular defined)", ->
		inject (l10n) -> service = l10n
		expect(service.getLocale()).toEqual('en-us')

describe 'provider to service', ->
	it "default locale can be changed using l10nProvider.setLocale", ->
		angular.module('provider2service', ['l10n']).config (l10nProvider) ->
			l10nProvider.setLocale 'uk-UA'
		module 'provider2service'
		inject (l10n) ->
			expect(l10n.getLocale()).toEqual('uk-UA')
