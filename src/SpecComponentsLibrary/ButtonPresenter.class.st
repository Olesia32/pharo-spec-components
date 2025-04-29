Class {
	#name : 'ButtonPresenter',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
ButtonPresenter >> fontColor: aColor [
self setGeneratedStyleProperty: #color value: aColor
]

{ #category : 'as yet unclassified' }
ButtonPresenter >> initializePresenters [

	| button |
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

{ #category : 'as yet unclassified' }
ButtonPresenter >> onClick: aBlock [ 
    self mainPresenter action: aBlock
]
