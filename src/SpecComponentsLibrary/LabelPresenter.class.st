"
I am a styled wrapper around `SpLabelPresenter`.  
I provide label rendering with support for font size, color, alignment, and weight customization through style properties.  
My label text is accessible via #text and #text:.

### Hierarchy

`SpAbstractPresenter`  
  `SpPresenter`  
    `BasePresenter`  
      `LabelPresenter` (this is me)

### Usage

```smalltalk
l := LabelPresenter new
text: 'Enter your name';
fontSize: 16; italic; color: Color gray.
"
Class {
	#name : 'LabelPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary-BaseComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'BaseComponents'
}

{ #category : 'initialization' }
LabelPresenter >> initializePresenters [

	| tmp1 |
	super initializePresenters.
	tmp1 := SpLabelPresenter new.
	self focusOrder add: tmp1.
	self mainPresenter: tmp1
]

{ #category : 'accessing' }
LabelPresenter >> text [

	^ mainPresenter label
]

{ #category : 'accessing' }
LabelPresenter >> text: aString [

	mainPresenter label: aString
]
