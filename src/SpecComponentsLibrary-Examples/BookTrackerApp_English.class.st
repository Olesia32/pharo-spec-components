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
	#name : 'BookTrackerApp_English',
	#superclass : 'SpApplication',
	#instVars : [
		'repository'
	],
	#category : 'SpecComponentsLibrary-Examples-BookTracker',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'BookTracker'
}

{ #category : 'initialization' }
BookTrackerApp_English >> initialize [ 
  super initialize.
  repository := BookTrackerRepository new.
]

{ #category : 'as yet unclassified' }
BookTrackerApp_English >> openLoginWindow [

	| form window validation formStyle |
	repository := BookTrackerRepository new.

	validation := ValidationRules new
		              addRulePair: ValidationRules nonEmpty;
		              yourself.

	form := DynamicFormBuilder new
		        textField: #username
		        label: 'Login'
		        placeholder: ''
		        rules: validation.

	form
		textField: #password
		label: 'Password'
		placeholder: ''
		rules: validation.

	(form presenterAt: 'password') mainPresenter bePassword.

	form submitButtonLabel: 'Sign in'.
	form height: 150.

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
						message: 'Invalid login or password';
						title: 'Login Error';
						show.
					^ self ].

			form owner ifNotNil: [ :o |
					o delete.
					self openMainWindow: login ] ].
	form
		backButtonLabel: 'Register';
		onBack: [
				form owner ifNotNil: [ :o | o delete ].
				self openRegisterWindow ].

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
	window title: 'Sign in'.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]

{ #category : 'as yet unclassified' }
BookTrackerApp_English >> openMainWindow: aUsername [

	| window |
	window := self newPresenter: BookTrackerMainWindow_English.
	window username: aUsername.
	window := window open.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]

{ #category : 'as yet unclassified' }
BookTrackerApp_English >> openRegisterWindow [

	| form window validation formStyle |
	validation := ValidationRules new
		              addRulePair: ValidationRules nonEmpty;
		              addRulePair: (ValidationRules minLength: 4);
		              yourself.

	form := DynamicFormBuilder new
		        textField: #username
		        label: 'Login'
		        placeholder: ''
		        rules: validation.

	form
		textField: #password
		label: 'Password'
		placeholder: ''
		rules: validation.

	form submitButtonLabel: 'Register'.
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
							message: 'User already exists';
							title: 'Error';
							show ] ].

	form
		backButtonLabel: 'Sign in';
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
window title: 'Registration'.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]

{ #category : 'accessing' }
BookTrackerApp_English >> repository [
 ^repository 
]

{ #category : 'running' }
BookTrackerApp_English >> start [  
   self openLoginWindow 
]
