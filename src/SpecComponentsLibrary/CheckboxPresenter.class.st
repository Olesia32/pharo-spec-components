"
I am a styled wrapper for a single `SpCheckBoxPresenter`.  
I support styling through `BasePresenter` and can be used independently or inside a group (`CheckboxGroupPresenter`).  
My internal checkbox presenter can be accessed via `mainPresenter`.

### Hierarchy

`SpAbstractPresenter`  
  `SpPresenter`  
    `BasePresenter`  
      `CheckboxPresenter` (this is me)

### Usage

Use me for simple yes/no choices or as part of larger forms:

```smalltalk
c := CheckboxPresenter new;
mainPresenter label: 'Subscribe to newsletter';
bold; fontSize: 12.


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

	| tmp1 |
	super initializePresenters.
	tmp1 := SpCheckBoxPresenter new.
	self focusOrder add: tmp1.
	self mainPresenter: tmp1
]
