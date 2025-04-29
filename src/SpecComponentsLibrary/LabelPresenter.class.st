Class {
	#name : 'LabelPresenter',
	#superclass : 'BasePresenter',
	#instVars : [
		'label',
		'styleProperties',
		'styleApplied'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
LabelPresenter >> bold [
    self setGeneratedStyleProperty: #bold value: true.
]

{ #category : 'accessing' }
LabelPresenter >> color: aColor [

	self setGeneratedStyleProperty: #color value: aColor.
	
]

{ #category : 'as yet unclassified' }
LabelPresenter >> defaultLayout [
   self generateAndApplyStyle.
	^ SpBoxLayout newTopToBottom
		  add: label;
		  yourself
]

{ #category : 'accessing' }
LabelPresenter >> fontSize: aNumber [

	self setGeneratedStyleProperty: #fontSize value: aNumber
]

{ #category : 'as yet unclassified' }
LabelPresenter >> generateAndApplyStyle [

	| styleName |
	styleName := StyleManager
		             installGeneratedStyleFrom: self styleProperties
		             in: self application.
	label addStyle: styleName
]

{ #category : 'initialization' }
LabelPresenter >> initialize [

	super initialize.
	styleProperties := Dictionary new.
]

{ #category : 'initialization' }
LabelPresenter >> initializePresenters [

	label := SpLabelPresenter new.
	self focusOrder add: label
]

{ #category : 'accessing' }
LabelPresenter >> italic [
self setGeneratedStyleProperty: #italic value: true
]

{ #category : 'initialization' }
LabelPresenter >> setGeneratedStyleProperty: key value: val [
    self styleProperties at: key put: val.

]

{ #category : 'accessing' }
LabelPresenter >> styleProperties [
    "Гарантовано повертає словник (навіть якщо ще не створений)"
    styleProperties ifNil: [ styleProperties := Dictionary new ].
    ^ styleProperties
]

{ #category : 'accessing' }
LabelPresenter >> text [
    ^ label label.
]

{ #category : 'accessing' }
LabelPresenter >> text: aString [
    label label: aString.
]
