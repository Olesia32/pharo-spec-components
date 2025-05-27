"
I am a helper class for defining and applying validation rules to input fields.  
I provide ready-to-use rules on the class side (e.g., required fields, length checks, email format)  
and allow composing custom sets of rules on the instance side.  
Each rule is a block paired with a user-friendly error message.

### Public API

**Class-side**

- `ValidationRules class>>#nonEmpty` — returns a rule that requires non-empty text  
- `ValidationRules class>>#minLength:` — returns a rule that enforces minimum length  
- `ValidationRules class>>#maxLength:` — returns a rule that enforces maximum length  
- `ValidationRules class>>#isEmail` — returns a basic email format check  
- `ValidationRules class>>#matchesRegex:` — returns a rule based on a regex pattern

**Instance-side**

- `ValidationRules>>#addRule:message:` — adds a custom validation rule and error message  
- `ValidationRules>>#addRulePair:` — adds a rule/message pair as a 2-element association  
- `ValidationRules>>#all` — returns all added rules  
- `ValidationRules>>#applyTo:` — applies the stored rules to a `TextInputPresenter`

### Usage

To use predefined rules:

```smalltalk
input := TextInputPresenter new.
input isValidationField: true.
input addValidationRules: {
  ValidationRules nonEmpty.
  ValidationRules minLength: 6.
}.
```
or
```smalltalk
rules := ValidationRules new.
rules addRule: [ :text | text asInteger > 0 ] message: 'Must be a positive number'.
rules applyTo: input.

"
Class {
	#name : 'ValidationRules',
	#superclass : 'Object',
	#instVars : [
		'customRules'
	],
	#category : 'SpecComponentsLibrary-ValidatedInput',
	#package : 'SpecComponentsLibrary',
	#tag : 'ValidatedInput'
}

{ #category : 'accessing' }
ValidationRules class >> isEmail [
"Returns a simple email validation rule that checks for presence of @ or . in the text."
	^ [ :text | (text includes: $@) or: [ text includes: $. ] ]
	  -> 'Некоректний email'
]

{ #category : 'accessing' }
ValidationRules class >> matchesRegex: pattern [
	"Returns a rule that validates text using a regular expression pattern."

	^ [ :text | pattern matches: text ] -> 'Недопустимий формат'
]

{ #category : 'accessing' }
ValidationRules class >> maxLength: n [
"Returns a rule that requires the text to be shorter than a given number of characters."
	^ [ :text | text size < n ]
	  -> ('Максимальна довжина — ' , n printString)
]

{ #category : 'accessing' }
ValidationRules class >> minLength: n [
	"Returns a rule that requires the text to be longer than a given number of characters."

	^ [ :text | text size > n ]
	  -> ('Мінімальна довжина — ' , n printString)
]

{ #category : 'accessing' }
ValidationRules class >> nonEmpty [
"Returns a validation rule that fails if the input is nil or an empty string.
The rule is returned as a block-message pair."
	^ [ :text | text notNil and: [ text isNotEmpty ] ]
	  -> 'Поле не може бути порожнім'
]

{ #category : 'adding' }
ValidationRules >> addRule: aBlock message: aMessage [
"Adds a single validation rule to the internal list.
The rule is a block, and the message is shown if the rule fails."
	customRules add: aBlock -> aMessage
]

{ #category : 'adding' }
ValidationRules >> addRulePair: aPair [
"Adds a pre-constructed association (rule → message) to the rule list.
Useful when reusing class-side rules."
	customRules add: aPair
]

{ #category : 'accessing' }
ValidationRules >> all [
"Returns the collection of all rule-message pairs currently stored."
	^ customRules
]

{ #category : 'operations' }
ValidationRules >> applyTo: aPresenter [
"Applies all stored rules to the given TextInputPresenter by calling #addValidationRule:message: for each."
	customRules do: [ :pair |
		aPresenter addValidationRule: pair key message: pair value ]
]

{ #category : 'initialization' }
ValidationRules >> initialize [

   super initialize.
	customRules := OrderedCollection new.
	^ self
]
