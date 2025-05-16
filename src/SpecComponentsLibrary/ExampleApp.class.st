Class {
	#name : 'ExampleApp',
	#superclass : 'SpApplication',
	#instVars : [
		'mainPresenter'
	],
	#category : 'SpecComponentsLibrary-Examples',
	#package : 'SpecComponentsLibrary',
	#tag : 'Examples'
}

{ #category : 'initialization' }
ExampleApp >> initialize [

	super initialize.
	
]

{ #category : 'initialization' }
ExampleApp >> start [

	| window p |
	p := LibraryTable new.
	p application: self.
	window := p open.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]
