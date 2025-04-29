Class {
	#name : 'ValidatedTextFieldPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textInputField',
		'validationBlock'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
ValidatedTextFieldPresenter >> connectSignals [
    textInputField whenTextChangedDo: [ self validateInput ].
]

{ #category : 'initialization' }
ValidatedTextFieldPresenter >> initializeStyle [
    super initializeStyle.
    style := StyleManager default styleFor: #textField.
    self applyStyle
]

{ #category : 'initialization' }
ValidatedTextFieldPresenter >> initializeView [

	textInputField := self newTextInput.
	view := textInputField.
	self connectSignals
]

{ #category : 'as yet unclassified' }
ValidatedTextFieldPresenter >> markInvalid [
    view borderColor: Color red.
]

{ #category : 'as yet unclassified' }
ValidatedTextFieldPresenter >> markValid [
    view borderColor: Color green.
]

{ #category : 'as yet unclassified' }
ValidatedTextFieldPresenter >> validateInput [
    validationBlock ifNotNil: [
        (validationBlock value: self value)
            ifFalse: [ self markInvalid ]
            ifTrue: [ self markValid ]
    ]
]

{ #category : 'as yet unclassified' }
ValidatedTextFieldPresenter >> validationBlock: aBlock [
    validationBlock := aBlock
]

{ #category : 'as yet unclassified' }
ValidatedTextFieldPresenter >> value [
    ^ textInputField text
]

{ #category : 'as yet unclassified' }
ValidatedTextFieldPresenter >> value: aString [
    textInputField text: aString
]
