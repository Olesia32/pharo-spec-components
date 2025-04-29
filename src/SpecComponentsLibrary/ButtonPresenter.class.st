Class {
	#name : 'ButtonPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'buttonMorph',
		'label',
		'actionBlock'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'private' }
ButtonPresenter >> applyStyle [
    buttonMorph color: (style at: #backgroundColor ifAbsent: [ Color gray ]).
    buttonMorph labelMorph color: (style at: #textColor ifAbsent: [ Color black ]).
]

{ #category : 'as yet unclassified' }
ButtonPresenter >> buttonAction [
    actionBlock ifNotNil: [ actionBlock value ].
]

{ #category : 'morphic ui' }
ButtonPresenter >> buttonEnabled [
    ^ true
]

{ #category : 'private' }
ButtonPresenter >> buttonLabel [
    ^ label
]

{ #category : 'initialization' }
ButtonPresenter >> initializeStyle [
    super initializeStyle.
    style := StyleManager default styleFor: #button.
    self applyStyle
]

{ #category : 'initialization' }
ButtonPresenter >> initializeView [
    label := ''.
buttonMorph := PluggableButtonMorph
    on: self
    getState: #buttonEnabled
    action: #buttonAction
    label: #buttonLabel.
    view := buttonMorph.
]

{ #category : 'as yet unclassified' }
ButtonPresenter >> onClick: aBlock [
    "Реєструвати дію на клік."
    actionBlock := aBlock
]

{ #category : 'private' }
ButtonPresenter >> text [
    ^ label
]

{ #category : 'private' }
ButtonPresenter >> text: aString [
    label := aString.
    buttonMorph label: label
]
