Class {
	#name : 'CheckboxPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
CheckboxPresenter >> initializePresenters [

	| checkbox |
	checkbox := SpCheckBoxPresenter new.
	self focusOrder add: checkbox.
	self mainPresenter: checkbox
]
