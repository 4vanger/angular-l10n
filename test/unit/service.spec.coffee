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
	it 'should get messages from current locale as service keys', ->
		expect(service.message).toBe 'one'
	it 'should get nested messages', ->
		expect(service.get('key.with.dots')).toBe 'key.with.dots'
		expect(service.get('nested.message')).toBe 'nested message'
		expect(service.get('nested.nested.message')).toBe 'nested nested message'
	it 'should get nested messages as service keys', ->
		expect(service.nested.message).toBe 'nested message'
		expect(service.nested.nested.message).toBe 'nested nested message'
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

describe 'l10n directives', ->
	compile = null
	scope = null
	service = null
	beforeEach ->
		angular.module('test-directive', ['l10n', 'l10n-tools']).config (l10nProvider) ->
			l10nProvider.add 'en-US',
				directive:
					dirText: 'This line is inserted using l10n-text directive'
					dirHtml: 'This line is inserted using l10n-html directive. And it has <b><i>HTML markup</i></b>'
					dirTitle: 'This title is inserted using l10n-title directive'
					dirPlaceholder: 'This placeholder is inserted using l10n-placeholder directive'
					dirHref: 'http://en.example.com/Localized link'
					dirValue: 'This line is inserted using l10n-value directive'
			l10nProvider.add 'uk-UA',
				directive:
					dirText: 'UAThis line is inserted using l10n-text directive'
					dirHtml: 'UAThis line is inserted using l10n-html directive. And it has <b><i>HTML markup</i></b>'
					dirTitle: 'UAThis title is inserted using l10n-title directive'
					dirPlaceholder: 'UAThis placeholder is inserted using l10n-placeholder directive'
					dirHref: 'http://ua.example.com/Localized link'
					dirValue: 'UAThis line is inserted using l10n-value directive'

		module 'test-directive'
		inject ($compile, $rootScope, l10n) ->
			l10n.setLocale 'en-US'
			service = l10n
			scope = $rootScope
			compile = $compile
	setHTML = (html) ->
		el = angular.element(html)
		compile(el)(scope)
		scope.$digest()
		return el

	it 'should support l10n-text attribute', ->
		expect(setHTML('<div l10n-text="directive.dirText"></div>').html()).toBe 'This line is inserted using l10n-text directive'
	it 'should support l10n-html attribute', ->
		expect(setHTML('<div l10n-html="directive.dirHtml"></div>').html()).toBe 'This line is inserted using l10n-html directive. And it has <b><i>HTML markup</i></b>'
	it 'should support l10n-title attribute', ->
		expect(setHTML('<div l10n-title="directive.dirTitle"></div>').attr('title')).toBe 'This title is inserted using l10n-title directive'
	it 'should support l10n-placeholder attribute', ->
		expect(setHTML('<div l10n-placeholder="directive.dirPlaceholder"></div>').attr('placeholder')).toBe 'This placeholder is inserted using l10n-placeholder directive'
	it 'should support l10n-href attribute', ->
		expect(setHTML('<a l10n-href="directive.dirHref"></a>').attr('href')).toBe 'http://en.example.com/Localized link'
	it 'should support l10n-value attribute', ->
		expect(setHTML('<input l10n-value="directive.dirValue"/>').attr('value')).toBe 'This line is inserted using l10n-value directive'

	it 'should update directive values when locale is changed', ->
		service.setLocale 'uk-UA'
		expect(setHTML('<div l10n-text="directive.dirText"></div>').html()).toBe 'UAThis line is inserted using l10n-text directive'
		expect(setHTML('<div l10n-html="directive.dirHtml"></div>').html()).toBe 'UAThis line is inserted using l10n-html directive. And it has <b><i>HTML markup</i></b>'
		expect(setHTML('<div l10n-title="directive.dirTitle"></div>').attr('title')).toBe 'UAThis title is inserted using l10n-title directive'
		expect(setHTML('<div l10n-placeholder="directive.dirPlaceholder"></div>').attr('placeholder')).toBe 'UAThis placeholder is inserted using l10n-placeholder directive'
		expect(setHTML('<a l10n-href="directive.dirHref"></a>').attr('href')).toBe 'http://ua.example.com/Localized link'
		expect(setHTML('<input l10n-value="directive.dirValue"/>').attr('value')).toBe 'UAThis line is inserted using l10n-value directive'

describe 'l10n using interpolation', ->
	compile = null
	scope = null
	beforeEach ->
		angular.module('test-directive', ['l10n', 'l10n-tools']).config (l10nProvider) ->
			l10nProvider.add 'en-US',
				interpolation:
					message: 'This message is inserted through interpolation using object property.'
					nested:
						message: 'this is nested message'
			l10nProvider.add 'uk-UA',
				interpolation:
					message: 'UAThis message is inserted through interpolation using object property.'
					nested:
						message: 'UAthis is nested message'

		module 'test-directive'
		inject ($compile, $rootScope, l10n) ->
			l10n.setLocale 'en-US'
			scope = $rootScope
			scope.l10n = l10n
			compile = $compile
	setText = (text) ->
		el = angular.element('<div>' + text + '</div>')
		compile(el)(scope)
		scope.$digest()
		return el.html()

	it 'should work as service keys', ->
		expect(setText('{{ l10n.interpolation.message }}')).toBe 'This message is inserted through interpolation using object property.'
	it 'should work when .get method is used', ->
		expect(setText('{{ l10n.get("interpolation.message")}}')).toBe 'This message is inserted through interpolation using object property.'
describe 'l10n filter', ->
	filter = null
	service = null
	beforeEach ->
		angular.module('test-filter', ['l10n', 'l10n-tools']).config (l10nProvider) ->
			l10nProvider.add 'en-US',
				filter:
					hello: 'Hello, filter'
					hello2: 'Hello %1 and %2'
			l10nProvider.add 'uk-UA',
				filter:
					hello: 'UAHello, filter'
					hello2: 'UAHello %1 and %2'

		module 'test-filter'
		inject ($filter, l10n) ->
			l10n.setLocale 'en-US'
			service = l10n
			filter = $filter

	it 'should work', ->
		expect(filter('l10n')('filter.hello')).toBe 'Hello, filter'
	it 'should accept params', ->
		expect(filter('l10n')('filter.hello2')).toBe 'Hello %1 and %2'
		expect(filter('l10n')('filter.hello2', 'one')).toBe 'Hello one and %2'
		expect(filter('l10n')('filter.hello2', 'one', 'two')).toBe 'Hello one and two'
		expect(filter('l10n')('filter.hello2', 'one', 'two', 'three')).toBe 'Hello one and two'
	it 'should respect active locale', ->
		expect(filter('l10n')('filter.hello')).toBe 'Hello, filter'
		service.setLocale 'uk-UA'
		expect(filter('l10n')('filter.hello')).toBe 'UAHello, filter'
describe 'provider to service', ->
	it 'default locale can be changed using l10nProvider.setLocale', ->
		angular.module('provider2service', ['l10n']).config (l10nProvider) ->
			l10nProvider.setLocale 'uk-UA'
		module 'provider2service'
		inject (l10n) ->
			expect(l10n.getLocale()).toEqual('uk-UA')
