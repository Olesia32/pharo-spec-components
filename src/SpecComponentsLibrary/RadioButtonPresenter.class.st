"
I am a styled wrapper around `SpRadioButtonPresenter`.  
I am used inside a `RadioGroupPresenter` to display and manage mutually exclusive options.  
All visual properties (color, font, size) can be controlled through `BasePresenter`.

### Hierarchy

`SpAbstractPresenter`  
  `SpPresenter` 
    `BasePresenter`  
      `RadioButtonPresenter` (this is me)

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
