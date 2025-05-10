"
Обгортка над стандартним SpListPresenter.
Підтримує візуальну стилізацію.

"
Class {
	#name : 'ListPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary-BaseComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'BaseComponents'
}

{ #category : 'initialization' }
ListPresenter >> initializePresenters [

	| list |
	super initializePresenters.
	list := SpListPresenter new.
	self focusOrder add: list.
	self mainPresenter: list
]
