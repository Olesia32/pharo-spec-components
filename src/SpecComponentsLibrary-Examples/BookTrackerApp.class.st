"
I am the main application class of the BookTracker example.

I launch the user interface, manage transitions between login, registration, and the main window, and coordinate user validation. I demonstrate how components of the `SpecComponentsLibrary` can be combined to build a minimal user authentication flow. I use a `BookTrackerRepository` to manage user data and delegate UI rendering to dynamically generated forms.

### Instance Variables

**repository** `BookTrackerRepository` — stores and retrieves user data.

### Public API

- `BookTrackerApp>>#start` - opens the login window and starts the application.
- `BookTrackerApp>>#repository` - returns the repository instance used for user management.

### Window Management

- `BookTrackerApp>>#openLoginWindow` - builds a login form with validation. Opens the main window on success or shows a notification on failure. Also allows switching to the registration form.
- `BookTrackerApp>>#openRegisterWindow` - builds a registration form. If the entered username is unique, creates a new user and returns to login. Otherwise shows a warning.
- `BookTrackerApp>>#openMainWindow:` - opens the main interface for a logged-in user.

### Styling

All windows are styled via a `FormStyle` object, with unified input dimensions and color schemes. Expand/collapse/menu window controls are disabled for a cleaner look.

### Example

```smalltalk
BookTrackerApp new start

"
Class {
	#name : 'BookTrackerApp',
	#superclass : 'SpApplication',
	#instVars : [
		'repository'
	],
	#category : 'SpecComponentsLibrary-Examples-BookTracker',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'BookTracker'
}

{ #category : 'initialization' }
BookTrackerApp >> initialize [ 
  super initialize.
  repository := BookTrackerRepository new.
]

{ #category : 'as yet unclassified' }
BookTrackerApp >> openLoginWindow [

	| form window validation formStyle |
	repository := BookTrackerRepository new.

	"1. Валідація для обох полів"
	validation := ValidationRules new
		              addRulePair: ValidationRules nonEmpty;
		              yourself.

	"2. Побудова форми"
	form := DynamicFormBuilder new
		        textField: #username
		        label: 'Логін'
		        placeholder: ''
		        rules: validation.

	form
		textField: #password
		label: 'Пароль'
		placeholder: ''
		rules: validation.

	(form presenterAt: 'password') mainPresenter bePassword.

	form submitButtonLabel: 'Увійти'.
	form height: 150.

	"3. Дії при натисканні кнопок"
	form onSubmit: [ :values |
			| user login pass |
			login := values at: #username.
			pass := values at: #password.
			user := repository getUserByLogin: login.

			(user isNil or: [ user password ~= pass ]) ifTrue: [
					NotificationPresenter new
						type: '#error';
						window: form window;
						position: '#topLeft';
						message: 'Неправильний логін або пароль';
						title: 'Помилка входу';
						show.
					^ self ].

			form owner ifNotNil: [ :o |
					o delete.
					self openMainWindow: login ] ].
	form
		backButtonLabel: 'Зареєструватися';
		onBack: [
				form owner ifNotNil: [ :o | o delete ].
				self openRegisterWindow ].

	"4. Стилізація"
	formStyle := FormStyle new
		             inputHeight: 40;
		             buttonBackground: '#8ca08b';
		             inputBackground: '#veryLightGray';
		             buttonWidth: 150;
		             buttonHeight: 50.
	form style: formStyle.
    
   form := PresenterDecorator wrap: form.
   form backgroundColor: '#white'.

	"5. Відображення у вікні"
	window := form open.
	window title: 'Вхід'.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]

{ #category : 'as yet unclassified' }
BookTrackerApp >> openMainWindow: aUsername [

	| window |
	window := self newPresenter: BookTrackerMainWindow.
	window username: aUsername.
	window := window open.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]

{ #category : 'as yet unclassified' }
BookTrackerApp >> openRegisterWindow [

	| form window validation formStyle |
	validation := ValidationRules new
		              addRulePair: ValidationRules nonEmpty;
		              addRulePair: (ValidationRules minLength: 4);
		              yourself.

	form := DynamicFormBuilder new
		        textField: #username
		        label: 'Логін'
		        placeholder: ''
		        rules: validation.

	form
		textField: #password
		label: 'Пароль'
		placeholder: ''
		rules: validation.

	form submitButtonLabel: 'Зареєструватись'.
	form height: 150.
	(form presenterAt: 'password') mainPresenter bePassword.
	form onSubmit: [ :values |
			| user exists |
			user := User new.
			user username: (values at: #username).
			user password: (values at: #password).

			exists := repository getUserByLogin: user username.
			exists
				ifNil: [
						repository addUser: user.
						form owner ifNotNil: [ :o | o delete ] ]
				ifNotNil: [
						NotificationPresenter new
							type: '#warning';
							window: form window;
							position: '#topLeft';
							message: 'Користувач вже існує';
							title: 'Помилка';
							show ] ].

	form
		backButtonLabel: 'Увійти';
		onBack: [
				form owner ifNotNil: [ :o | o delete ].
				self openLoginWindow ].

	formStyle := FormStyle new
		             inputHeight: 40;
		             buttonBackground: '#8ca08b';
		             inputBackground: '#veryLightGray';
		             buttonWidth: 150;
		             buttonHeight: 50.
	form style: formStyle.
	
	form := PresenterDecorator wrap: form.
	form backgroundColor: '#white'.

	window := form open.
	window title: 'Реєстрація'.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]

{ #category : 'accessing' }
BookTrackerApp >> repository [
 ^repository 
]

{ #category : 'running' }
BookTrackerApp >> start [  
   self openLoginWindow 
]
