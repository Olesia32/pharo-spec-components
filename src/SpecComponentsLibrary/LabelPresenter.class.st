"
Обгортка над стандартним SpLabelPresenter.
Підтримує візуальну стилізацію.
"
Class {
	#name : 'LabelPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary-BaseComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'BaseComponents'
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
