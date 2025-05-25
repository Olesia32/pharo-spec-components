"
I am a styled and validated input field presenter used for text entry.  
I extend `BasePresenter` to support dynamic styling and provide built-in validation support.  
When validation is enabled, I show an error message below the field and adjust the border color depending on validity.

### Hierarchy

`SpAbstractPresenter`  
  `SpPresenter`  
    `BasePresenter`  
      `TextInputPresenter` (this is me)

### Instance Variables

- _isValidationField_: a `Boolean` — enables or disables validation logic  
- _errorLabel_: a `LabelPresenter` — shows the validation error message  
- _validationRules_: a `Dictionary` — maps rule blocks to error messages  
- _isValid_: a `Boolean` — current validation result  
- _validationStatusModel_: a `ValueHolder<Boolean>` — notifies about validation changes

### Public API

- `TextInputPresenter>>#text`, `TextInputPresenter>>#text:` — gets or sets the input string  
- `TextInputPresenter>>#placeholder:` — sets the placeholder text  
- `TextInputPresenter>>#isValidationField`, `TextInputPresenter>>#isValidationField:` — enables validation behavior  
- `TextInputPresenter>>#isValid` — returns current validation state  
- `TextInputPresenter>>#addValidationRule:message:` — adds a rule and its error message  
- `TextInputPresenter>>#addValidationRules:` — adds multiple rules at once  
- `TextInputPresenter>>#validate` — checks the rules and updates the view  

### Events

- `TextInputPresenter>>#onValidationChangedDo:` — sets a callback for when validity changes

### Usage

```smalltalk
input := TextInputPresenter new.
input placeholder: 'Enter email'.
input isValidationField: true.
input addValidationRule: [ :text | text includes: '@' ] message: 'Email must include @'.
input onValidationChangedDo: [ :isOk | Transcript show: 'Valid? ', isOk printString; cr ].
input open.

"
Class {
	#name : 'TextInputPresenter',
	#superclass : 'BasePresenter',
	#instVars : [
		'isValidationField',
		'errorLabel',
		'validationRules',
		'isValid',
		'validationStatusModel'
	],
	#category : 'SpecComponentsLibrary-ValidatedInput',
	#package : 'SpecComponentsLibrary',
	#tag : 'ValidatedInput'
}

{ #category : 'adding' }
TextInputPresenter >> addValidationRule: arg1 message: arg2 [
"Adds a single validation rule to the form.
The rule is a block that takes the input string and returns a boolean; if it fails, the given message is shown."
	validationRules at: arg1 put: arg2
]

{ #category : 'adding' }
TextInputPresenter >> addValidationRules: arg1 [
"Adds multiple validation rules from a dictionary where each key is a rule block and each value is the error message."
	arg1 all do: [ :arg2 |
		self addValidationRule: arg2 key message: arg2 value ]
]

{ #category : 'initialization' }
TextInputPresenter >> connectPresenters [
"Connects validation logic to the input field.
When the text changes, #validate is called.
Also listens to validation status changes to update visual appearance (red or green border)."
	mainPresenter whenTextChangedDo: [ self validate ].

	self onValidationChangedDo: [ :isValidNow |
			isValidationField ifTrue: [
					isValidNow
						ifTrue: [ self borderColor: '#green' ]
						ifFalse: [ self borderColor: '#red' ].
					self borderWidth: 1 ] ]
]

{ #category : 'layout' }
TextInputPresenter >> defaultLayout [

	| tmp1 |
	self generateAndApplyStyle.
	tmp1 := SpBoxLayout newTopToBottom.
	tmp1
		add: mainPresenter.
	isValidationField ifTrue: [ tmp1 add: errorLabel. ].
	^ tmp1 yourself
]

{ #category : 'initialization' }
TextInputPresenter >> initialize [

	super initialize.
]

{ #category : 'initialization' }
TextInputPresenter >> initializePresenters [

   super initializePresenters.
	self mainPresenter: SpTextInputFieldPresenter new.
	errorLabel := LabelPresenter new.
	errorLabel
		text: '';
		color: '#red';
		fontSize: 10.
	errorLabel mainPresenter visibleIf: false.
	self focusOrder add: self mainPresenter.
	validationStatusModel := ValueHolder new.
	validationStatusModel contents: true.
	announcer := Announcer new.
	isValid := true.
	validationRules := Dictionary new.
	isValidationField := false
]

{ #category : 'accessing' }
TextInputPresenter >> isValid [
"Returns the current validation state (true or false)."
	^ isValid
]

{ #category : 'accessing' }
TextInputPresenter >> isValidationField [
"Returns whether validation is currently enabled."
	^ isValidationField
]

{ #category : 'accessing' }
TextInputPresenter >> isValidationField: aValue [
"Enables or disables validation mode.
Triggers a layout rebuild so the error label appears/disappears as needed."
	isValidationField := aValue.
	self defaultLayout
]

{ #category : 'events' }
TextInputPresenter >> onValidationChangedDo: aBlock [
"Registers a listener block that will be called when validation status changes.
Used to trigger external UI updates."
	announcer
		when: ValidationStatusChanged
		do: [ :evt | aBlock value: evt newValue ]
		for: self
]

{ #category : 'accessing' }
TextInputPresenter >> placeholder: arg1 [

	mainPresenter placeholder: arg1
]

{ #category : 'accessing' }
TextInputPresenter >> text [

	^ mainPresenter text
]

{ #category : 'accessing' }
TextInputPresenter >> text: arg1 [

	mainPresenter text: arg1
]

{ #category : 'validation' }
TextInputPresenter >> validate [
"Performs validation based on registered rules.

If validation is off → always returns true
If any rule fails → sets isValid to false, updates UI and shows the message
If all rules pass → sets isValid to true, hides the error label, and resets visuals
Triggers the ValidationStatusChanged event via announcer."

	| tmp1 |
	isValidationField not ifTrue: [
			isValid := true.
			validationStatusModel contents: true.
			errorLabel mainPresenter visibleIf: false.
			^ true ].

	tmp1 := self text.

	validationRules keysAndValuesDo: [ :rule :message |
			(rule value: tmp1) ifFalse: [
					isValid := false.
					validationStatusModel contents: false.
					announcer announce:
						(ValidationStatusChanged new newValue: isValid).
					errorLabel text: message.
					errorLabel mainPresenter visibleIf: true.
					^ false ] ].

	isValid := true.
	validationStatusModel contents: true.
	announcer announce: (ValidationStatusChanged new newValue: isValid).
	errorLabel text: ''.
	errorLabel mainPresenter visibleIf: false.
	^ true
]
