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
describe 'l10n.get method', ->
	provider = null
	service = null
	beforeEach ->
		angular.module('test-get', ['l10n']).config (l10nProvider) ->
			provider = l10nProvider
			l10nProvider.add 'en-US',
				message: 'one'
				nested:
					message: 'nested message'
					nested:
						message: 'nested nested message'
				'key.with.dots': 'value'
				references:
					originalMessage: 'This is message from "originalMessage" resource'
					referencedMessage: '@references.originalMessage'
					referencedReferencedMessage: '@references.referencedMessage'
					escapedMessage: '\\@angularjs is nice twitter to follow'
				subs:
					hello: 'Hello, %1'
					hello2: 'Hello, %1 and %2'
				objects:
					monthsArr: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
					pluralizeParams:
						'0': 'Nobody is viewing.'
						'one': '1 person is viewing.'
						'other': '{} people are viewing.'

		module 'test-get'
		inject (l10n) ->
			service = l10n
			l10n.setLocale 'en-US'
	afterEach ->
		# cleanup
		provider.locale = null
		provider.localeMessages = {}
		provider.db = {}
	it 'should get messages from current locale', ->
		expect(service.get('message')).toBe 'one'
	it 'should get nested messages', ->
		expect(service.get('key.with.dots')).toBe 'key.with.dots'
		expect(service.get('nested.message')).toBe 'nested message'
		expect(service.get('nested.nested.message')).toBe 'nested nested message'
	it 'should be able to reference messages using @ sign', ->
		expect(service.get('references.referencedMessage')).toBe 'This is message from "originalMessage" resource'
		expect(service.get('references.referencedReferencedMessage')).toBe 'This is message from "originalMessage" resource'
	it 'should be able to substitute params', ->
		expect(service.get('subs.hello')).toBe 'Hello, %1'
		expect(service.get('subs.hello', null)).toBe 'Hello, null'
		expect(service.get('subs.hello', 123)).toBe 'Hello, 123'
		expect(service.get('subs.hello', 'name')).toBe 'Hello, name'
		expect(service.get('subs.hello', 'name', 'name2')).toBe 'Hello, name'
		expect(service.get('subs.hello2')).toBe 'Hello, %1 and %2'
		expect(service.get('subs.hello2', 'name')).toBe 'Hello, name and %2'
		expect(service.get('subs.hello2', 'name', 'name2')).toBe 'Hello, name and name2'
		expect(service.get('subs.hello2', 'name', 'name2', 'name3' )).toBe 'Hello, name and name2'
		expect(service.get('%1 %2 %3 %4 %5 %6 %7 %8 %9 %10', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)).toBe '1 2 3 4 5 6 7 8 9 10'

describe 'provider to service', ->
	it 'default locale can be changed using l10nProvider.setLocale', ->
		angular.module('provider2service', ['l10n']).config (l10nProvider) ->
			l10nProvider.setLocale 'uk-UA'
		module 'provider2service'
		inject (l10n) ->
			expect(l10n.getLocale()).toEqual('uk-UA')
