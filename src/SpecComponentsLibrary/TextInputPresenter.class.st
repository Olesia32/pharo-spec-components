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
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'adding' }
TextInputPresenter >> addValidationRule: arg1 message: arg2 [

	validationRules at: arg1 put: arg2
]

{ #category : 'adding' }
TextInputPresenter >> addValidationRules: arg1 [

	arg1 all do: [ :arg2 |
		self addValidationRule: arg2 key message: arg2 value ]
]

{ #category : 'as yet unclassified' }
TextInputPresenter >> connectPresenters [

	mainPresenter whenTextChangedDo: [ self validate ].

	self onValidationChangedDo: [ :isValidNow |
			isValidationField ifTrue: [
					isValidNow
						ifTrue: [ self borderColor: '#green' ]
						ifFalse: [ self borderColor: '#red' ].
					self borderWidth: 1 ] ]
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
TextInputPresenter >> initializePresenters [

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

{ #category : 'initialization' }
TextInputPresenter >> isValid [

	^ isValid
]

{ #category : 'accessing' }
TextInputPresenter >> isValidationField [

	^ isValidationField
]

{ #category : 'accessing' }
TextInputPresenter >> isValidationField: aValue [

	isValidationField := aValue.
	self defaultLayout 
]

{ #category : 'enumerating' }
TextInputPresenter >> onValidationChangedDo: aBlock [

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

{ #category : 'initialization' }
TextInputPresenter >> validate [ 
	| tmp1 |

	(isValidationField not) ifTrue: [
		isValid := true.
		validationStatusModel contents: true.
		errorLabel mainPresenter visibleIf: false.
		^ true
	].

	tmp1 := self text.

	validationRules keysAndValuesDo: [ :rule :message |
		(rule value: tmp1) ifFalse: [
			isValid := false.
			validationStatusModel contents: false.
			announcer announce: (ValidationStatusChanged new newValue: isValid).
			errorLabel text: message.
			errorLabel mainPresenter visibleIf: true.
			^ false
		]
	].

	isValid := true.
	validationStatusModel contents: true.
	announcer announce: (ValidationStatusChanged new newValue: isValid).
	errorLabel text: ''.
	errorLabel mainPresenter visibleIf: false.
	^ true
]
