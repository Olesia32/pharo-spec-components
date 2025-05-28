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

	| tmp1 |
	super initializePresenters.
	tmp1 := SpRadioButtonPresenter new.
	self focusOrder add: tmp1.
	self mainPresenter: tmp1
]
