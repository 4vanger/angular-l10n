# L10n module for Angular.js
## [General features demo](http://4vanger.github.com/angular-l10n/) 
## [Demo of easy transitioning to angular-l10n](http://4vanger.github.com/angular-l10n/translation.html)
***
## Installation
```javascript
angular.module('MyApp', ['l10n']);
```

## Create your own localization resources

en.js
```javascript
angular.module('my-l10n-en', ['l10n']).config(['l10nProvider', function(l10n){
	l10n.add('en', {
		myPage: {
			myString: 'This is my string in English'
		}
	});
}])
```

ru.js
```javascript
angular.module('my-l10n-ru', ['l10n']).config(['l10nProvider', function(l10n){
	l10n.add('ru', {
		myPage: {
			myString: 'Моя строчка на русском'
		}
	});
}]
```

Then add it into your module requires:
```javascript
angular.module('MyApp', ['l10n', 'my-l10n-en']);
```


## Usage
### As a service
angular.module('MyApp').controller('MyCtrl', function(l10n){
	l10n.get('myPage.myString')
})
### As a directive
First you need to add l10n-tools as you module requirment
```javascript
angular.module('MyApp', ['l10n', 'l10n-tools']);
```
then you will get following attribute directives:
* l10n-html - set localized value as element HTML
* l10n-text - set localized value as element text content
* l10n-title, l10n-href, l10n-placeholder - set localized value as corresponding attribute value

[See demo](http://4vanger.github.com/angular-l10n/) for more features and examples of usage.