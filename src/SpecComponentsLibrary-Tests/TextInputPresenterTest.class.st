Class {
	#name : 'TextInputPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'input'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
TextInputPresenterTest >> classToTest [ 
   ^ TextInputPresenter 
]

{ #category : 'running' }
TextInputPresenterTest >> setUp [ 
	super setUp.
	input := TextInputPresenter new.
	input initializePresenters.
]

{ #category : 'tests' }
TextInputPresenterTest >> testAddValidationRuleMessage [

	input isValidationField: true.
	input addValidationRule: [ :t | t size > 3 ] message: 'Too short'.

	self assert: (input instVarNamed: 'validationRules') size equals: 1
]

{ #category : 'tests' }
TextInputPresenterTest >> testAddValidationRules [

	| rules |
	input isValidationField: true.

	rules := ValidationRules new
		         addRulePair: ValidationRules nonEmpty;
		         addRulePair: ValidationRules isEmail.
	input addValidationRules: rules.

	"Fails both"
	input text: ''.
	input validate.
	self deny: input isValid.

	"Fails one"
	input text: 'hello'.
	input validate.
	self deny: input isValid.

	"Passes all"
	input text: 'hello@example.com'.
	input validate.
	self assert: input isValid
]

{ #category : 'tests' }
TextInputPresenterTest >> testIsValidationField [

	self deny: input isValidationField.

	input isValidationField: true.
	self assert: input isValidationField.

	input isValidationField: false.
	self deny: input isValidationField
]

{ #category : 'tests' }
TextInputPresenterTest >> testOnValidationChangedDo [

	| observed |
	input isValidationField: true.
	input
		addValidationRule: [ :t | t includes: $a ]
		message: 'Must include a'.

	observed := nil.
	input onValidationChangedDo: [ :val | observed := val ].

	input text: 'b'.
	input validate.
	self deny: observed.

	input text: 'abc'.
	input validate.
	self assert: observed
]

{ #category : 'tests' }
TextInputPresenterTest >> testPlaceholder [

	input := TextInputPresenter new.
	input placeholder: 'Enter name'.
	self assert: input mainPresenter placeholder equals: 'Enter name'.
]

{ #category : 'tests' }
TextInputPresenterTest >> testText [

	input text: 'Hello world'.
	self assert: input text equals: 'Hello world'.

	input text: ''.
	self assert: input text isEmpty
]

{ #category : 'tests' }
TextInputPresenterTest >> testValidate [

	input isValidationField: true.
	input addValidationRule: [ :t | t size > 3 ] message: 'Too short'.

	input text: 'Hello'.
	self assert: input validate.
	self assert: input isValid.
	
   input isValidationField: true.
	input addValidationRule: [ :t | t size > 3 ] message: 'Too short'.

	input text: 'Hi'.
	self deny: (input validate).
	self deny: input isValid.
]

{ #category : 'tests' }
TextInputPresenterTest >> testValidateShowsErrorMessage [

	input isValidationField: true.
	input
		addValidationRule: [ :t | t includes: $a ]
		message: 'Must contain a'.

	input text: 'hello'.
	input validate.
	self
		assert: (input instVarNamed: 'errorLabel') text
		equals: 'Must contain a'.
	self assert:
		(input instVarNamed: 'errorLabel') mainPresenter isVisible.

	input text: 'hallo'.
	input validate.
	self deny: (input instVarNamed: 'errorLabel') mainPresenter isVisible
]

{ #category : 'tests' }
TextInputPresenterTest >> testValidateWithoutValidationModeAlwaysTrue [ 

	input addValidationRule: [ :t | false ] message: 'Never valid'.
	input text: 'anything'.
	input validate.
	self assert: input isValid
]
