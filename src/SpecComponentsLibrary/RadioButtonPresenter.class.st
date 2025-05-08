Class {
	#name : 'RadioButtonPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
RadioButtonPresenter >> initializePresenters [

	| button |
	super initializePresenters.
	button := SpRadioButtonPresenter new.
	self focusOrder add: button.
	self mainPresenter: button
]
