Class {
	#name : 'ListPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
ListPresenter >> initializePresenters [

	| list |
	list := SpListPresenter new.
	self focusOrder add: list.
	self mainPresenter: list
]
