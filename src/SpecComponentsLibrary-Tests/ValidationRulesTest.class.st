Class {
	#name : 'ValidationRulesTest',
	#superclass : 'TestCase',
	#instVars : [
		'rules'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
ValidationRulesTest >> classToTest [ 
  ^ ValidationRules 
]

{ #category : 'running' }
ValidationRulesTest >> setUp [ 
	super setUp.
	rules := ValidationRules new.
]

{ #category : 'tests' }
ValidationRulesTest >> testAddRuleMessage [

	rules addRule: [ :t | t = 'yes' ] message: 'Must be yes'.
	self assert: rules all size equals: 1.
	self assert: rules all first value equals: 'Must be yes'.
	self assert: (rules all first key value: 'yes').
	self deny: (rules all first key value: 'no')
]

{ #category : 'tests' }
ValidationRulesTest >> testAddRulePair [

	| pair |
	pair := [ :t | t beginsWith: 'A' ] -> 'Must start with A'.
	rules addRulePair: pair.
	self assert: rules all size equals: 1.
	self assert: rules all first value equals: 'Must start with A'
]

{ #category : 'tests' }
ValidationRulesTest >> testApplyTo [
	| input |
	input := TextInputPresenter new.
	input isValidationField: true.

	rules addRule: [ :t | t size > 2 ] message: 'Too short'.
	rules applyTo: input.

	input text: 'ok'.
	input validate.
	self deny: input isValid.

	input text: 'okay'.
	input validate.
	self assert: input isValid.
]

{ #category : 'tests' }
ValidationRulesTest >> testIsEmail [

	| pair rule |
	pair := ValidationRules isEmail.
	rule := pair key.

	self assert: (rule value: 'user@example.com').
	self assert: (rule value: 'admin@mail').
	self deny: (rule value: 'invalid').
	self assert: pair value equals: 'Некоректний email'
]

{ #category : 'tests' }
ValidationRulesTest >> testMatchesRegex [

	| pair rule pattern |
	pattern := '^[0-9]{3}$' asRegex.
	pair := ValidationRules matchesRegex: pattern.
	rule := pair key.

	self assert: (rule value: '123').
	self deny: (rule value: 'abc').
	self deny: (rule value: '1234').
	self assert: pair value equals: 'Недопустимий формат'
]

{ #category : 'tests' }
ValidationRulesTest >> testMaxLength [

	| pair rule |
	pair := ValidationRules maxLength: 5.
	rule := pair key.

	self assert: (rule value: '1234').
	self deny: (rule value: '123456').
	self assert: pair value equals: 'Максимальна довжина — 5'
]

{ #category : 'tests' }
ValidationRulesTest >> testMinLength [

	| pair rule |
	pair := ValidationRules minLength: 5.
	rule := pair key.

	self assert: (rule value: 'abcdef').
	self deny: (rule value: 'abc').
	self assert: pair value equals: 'Мінімальна довжина — 5'
]

{ #category : 'tests' }
ValidationRulesTest >> testNonEmpty [

	| pair rule |
	pair := ValidationRules nonEmpty.
	rule := pair key.

	self assert: (rule value: 'Hello').
	self deny: (rule value: '').
	self deny: (rule value: nil).
	self assert: pair value equals: 'Поле не може бути порожнім'
]
