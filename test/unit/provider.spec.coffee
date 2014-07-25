describe "provider", ->
	provider = null
	beforeEach ->
		angular.module('test-app', ['l10n']).config (l10nProvider) -> provider = l10nProvider
		module 'test-app'
		inject ->
	describe "service", ->
		it 'Provider found', ->
			expect(provider).toBeDefined()
		it "Message DB is empty first", ->
			expect(provider.localeMessages).toEqual({})
		it "After appending messages DB is not empty", ->
			provider.add 'ru-RU', {key: 'message'}
			expect(provider.localeMessages).not.toEqual({})
