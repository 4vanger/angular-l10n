describe "L10n service", ->
	provider = null
	service = null
	beforeEach ->
		angular.module('test-service', ['l10n']).config (l10nProvider) ->
			provider = l10nProvider
			l10nProvider.add 'en-US', key: 'message-en'
			l10nProvider.add 'uk-UA', key: 'message-ua'

		module 'test-service'
		inject (l10n) -> service = l10n
	afterEach ->
		# cleanup
		provider.locale = null
		provider.localeMessages = {}
		provider.db = {}

	it 'should have en-us as default locale (angular defined)', ->
		expect(service.getLocale()).toEqual('en-us')

	it 'should return all locales with getAllLocales()', ->
		expect(service.getAllLocales()).toEqual(
			'en-US': key: 'message-en'
			'uk-UA': key: 'message-ua'
		)

	it 'should change locales using setLocale', ->
		service.setLocale 'en-US'
		expect(service.getLocale()).toBe('en-US')
		service.setLocale 'ua-UK'
		expect(service.getLocale()).toBe('ua-UK')
		service.setLocale 'en-US'

describe 'provider to service', ->
	it 'default locale can be changed using l10nProvider.setLocale', ->
		angular.module('provider2service', ['l10n']).config (l10nProvider) ->
			l10nProvider.setLocale 'uk-UA'
		module 'provider2service'
		inject (l10n) ->
			expect(l10n.getLocale()).toEqual('uk-UA')
