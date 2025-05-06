Class {
	#name : 'ButtonPresenter1',
	#superclass : 'BasePresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
ButtonPresenter1 >> backgroundColor: aColor [

  self adapter widget.
]

{ #category : 'as yet unclassified' }
ButtonPresenter1 >> initializePresenters [

	| button |
	button := SpButtonPresenter new.
	self focusOrder add: button.
	self mainPresenter: button 
]
