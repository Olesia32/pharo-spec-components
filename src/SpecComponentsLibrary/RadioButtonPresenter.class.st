Class {
	#name : 'RadioButtonPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
RadioButtonPresenter >> initializePresenters [ 

	| button |
	button := SpRadioButtonPresenter new.
	self focusOrder add: button.
	self mainPresenter: button
]
