"
Обгортка над стандартним SpButtonPresenter.
Підтримує візуальну стилізацію.
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
