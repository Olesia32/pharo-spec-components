"
I am a styled wrapper for a `SpListPresenter`.  
I can display a list of items and apply visual styling through inherited style properties.  
I support focus order and event registration via the inner `mainPresenter`.

### Hierarchy

`SpAbstractPresenter`  
  `SpPresenter`  
    `BasePresenter`  
      `ListPresenter` (this is me)

### Usage

```smalltalk
list := ListPresenter new
mainPresenter items: #('Item 1' 'Item 2');
height: 200; fontSize: 12.
"
Class {
	#name : 'ListPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary-BaseComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'BaseComponents'
}

{ #category : 'initialization' }
ListPresenter >> initializePresenters [

	| tmp1 |
	super initializePresenters.
	tmp1 := SpListPresenter new.
	self focusOrder add: tmp1.
	self mainPresenter: tmp1
]
