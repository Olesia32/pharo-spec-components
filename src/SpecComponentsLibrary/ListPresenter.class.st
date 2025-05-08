Class {
	#name : 'ListPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
ListPresenter >> initializePresenters [

	| list |
	super initializePresenters.
	list := SpListPresenter new.
	self focusOrder add: list.
	self mainPresenter: list
]
