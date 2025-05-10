"
Простий презентер для одного чекбокса.

Використовується самостійно або в складі форм і груп (CheckboxGroupPresenter). Підтримує візуальну стилізацію.

"
Class {
	#name : 'CheckboxPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary-BaseComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'BaseComponents'
}

{ #category : 'initialization' }
CheckboxPresenter >> initializePresenters [

	| checkbox |
	super initializePresenters.
	checkbox := SpCheckBoxPresenter new.
	self focusOrder add: checkbox.
	self mainPresenter: checkbox
]
