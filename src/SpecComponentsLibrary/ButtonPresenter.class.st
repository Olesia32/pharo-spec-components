"
I am a styled wrapper around `SpButtonPresenter`.  
I provide button functionality and expose a consistent interface for label setting, click handling, and visual customization.  
Style properties such as font size, color, width, and background can be applied through the inherited `BasePresenter`.

### Hierarchy

`SpAbstractPresenter`  
  `SpPresenter` 
    `BasePresenter`  
      `ButtonPresenter` (this is me)

### Usage

This presenter is typically used in dynamic forms, toolbars, or dialogs where a standard button with custom appearance is needed:

```smalltalk
|b|
b := ButtonPresenter new
label: 'Save';
onClick: [ self saveData ];
fontSize: 14; bold; backgroundColor: '#green'.

"
Class {
	#name : 'ButtonPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary-BaseComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'BaseComponents'
}

{ #category : 'style' }
ButtonPresenter >> fontColor: aColor [
self setGeneratedStyleProperty: #color value: aColor
]

{ #category : 'initialization' }
ButtonPresenter >> initializePresenters [

	| button |
	super initializePresenters.
	button := SpButtonPresenter new.
	self focusOrder add: button.
	self mainPresenter: button
]

{ #category : 'accessing' }
ButtonPresenter >> label [ 
    ^ self mainPresenter label
]

{ #category : 'accessing' }
ButtonPresenter >> label: aString [ 
    self mainPresenter label: aString
]

{ #category : 'events' }
ButtonPresenter >> onClick: aBlock [ 
    self mainPresenter action: aBlock
]
