Class {
	#name : 'ValidationRules',
	#superclass : 'Object',
	#instVars : [
		'customRules'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
ValidationRules class >> isEmail [

	^ [ :text | (text includes: $@) or: [ (text includes: $.)] ]
	  -> 'Некоректний email'
]

{ #category : 'accessing' }
ValidationRules class >> matchesRegex: pattern [

	^ [ :text | (pattern match: text) ] -> 'Недопустимий формат'
]

{ #category : 'accessing' }
ValidationRules class >> maxLength: n [

	^ [ :text | text size < n ]
	  -> ('Максимальна довжина — ' , n printString)
]

{ #category : 'accessing' }
ValidationRules class >> minLength: n [

	^ [ :text | text size > n ]
	  -> ('Мінімальна довжина — ' , n printString)
]

{ #category : 'requirements' }
ValidationRules class >> nonEmpty [

	^ [ :text | text notNil and: [ text isNotEmpty ] ]
	  -> 'Поле не може бути порожнім'
]

{ #category : 'adding' }
ValidationRules >> addRule: aBlock message: aMessage [ 
    customRules add: aBlock -> aMessage
]

{ #category : 'adding' }
ValidationRules >> addRulePair: aPair [ 
    customRules add: aPair
]

{ #category : 'accessing' }
ValidationRules >> all [ 
    ^ customRules 
]

{ #category : 'operations' }
ValidationRules >> applyTo: aPresenter [ 
    customRules do: [ :pair |
        aPresenter addValidationRule: pair key message: pair value
    ]
]

{ #category : 'initialization' }
ValidationRules >> initialize [

   super initialize.
	customRules := OrderedCollection new.
	^ self
]
