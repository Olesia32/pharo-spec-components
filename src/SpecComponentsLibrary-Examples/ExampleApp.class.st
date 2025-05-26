Class {
	#name : 'ExampleApp',
	#superclass : 'SpApplication',
	#instVars : [
		'mainPresenter'
	],
	#category : 'SpecComponentsLibrary-Examples-SimpleExamples',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'SimpleExamples'
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
