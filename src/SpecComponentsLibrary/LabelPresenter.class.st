Class {
	#name : 'LabelPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
LabelPresenter >> initializePresenters [

	| label |
	super initializePresenters.
	label := SpLabelPresenter new.
	self focusOrder add: label.
	self mainPresenter: label
]

{ #category : 'accessing' }
LabelPresenter >> text [

	^ mainPresenter label
]

{ #category : 'accessing' }
LabelPresenter >> text: aString [

	mainPresenter label: aString
]
