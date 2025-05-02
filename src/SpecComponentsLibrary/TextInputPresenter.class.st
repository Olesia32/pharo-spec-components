Class {
	#name : 'TextInputPresenter',
	#superclass : 'BasePresenter',
	#instVars : [
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

{ #category : 'as yet unclassified' }
TextInputPresenter >> connectPresenters [

	mainPresenter whenTextChangedDo: [ self validate ]
]

{ #category : 'as yet unclassified' }
TextInputPresenter >> defaultLayout [

	| tmp1 |
	self generateAndApplyStyle.
	tmp1 := SpBoxLayout newTopToBottom.
	tmp1
		add: mainPresenter;
		add: errorLabel.
	^ tmp1 yourself
]

{ #category : 'initialization' }
TextInputPresenter >> initialize [

	super initialize.
	isValid := true.
	validationRules := Dictionary new.
	validationStatusModel := Announcer new.
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
	self focusOrder add: self mainPresenter
]

{ #category : 'initialization' }
TextInputPresenter >> isValid [

	^ isValid
]

{ #category : 'enumerating' }
TextInputPresenter >> onValidationChangedDo: aBlock [ 
    validationStatusModel when: Boolean send: #value to: aBlock.
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
| text previousState |
    text := self text.
    previousState := isValid.

    validationRules keysAndValuesDo: [ :rule :message |
        (rule value: text) ifFalse: [
            isValid := false.
            errorLabel text: message.
            errorLabel mainPresenter visibleIf: true.
            previousState ~= isValid ifTrue: [ validationStatusModel announce: isValid ].
            ^ false.
        ].
    ].

    isValid := true.
    errorLabel text: ''.
    errorLabel mainPresenter visibleIf: false.
    previousState ~= isValid ifTrue: [ validationStatusModel announce: isValid ].
    ^ true.
]
