"
Презентер для однієї радіокнопки.

Використовується в складі групового компонента RadioGroupPresenter. Може бути стилізованим та інтегрованим у форми.

"
Class {
	#name : 'RadioButtonPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary-BaseComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'BaseComponents'
}

{ #category : 'initialization' }
RadioButtonPresenter >> initializePresenters [

	| button |
	super initializePresenters.
	button := SpRadioButtonPresenter new.
	self focusOrder add: button.
	self mainPresenter: button
]
