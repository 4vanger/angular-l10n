describe "service", ->
	beforeEach module('l10n')
	l10nService = null
	beforeEach inject (l10n) -> l10nService = l10n
	describe "service", ->
		it "by default locale is en-us (angular defined)", ->
			expect(l10nService.getLocale()).toEqual('en-us')
