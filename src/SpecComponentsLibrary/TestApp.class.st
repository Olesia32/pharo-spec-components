Class {
	#name : 'TestApp',
	#superclass : 'SpApplication',
	#instVars : [
		'mainPresenter'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
TestApp >> initialize [

	super initialize.
	
]

{ #category : 'initialization' }
TestApp >> start [

	| window p |
	p := TestPresenter new.
	p application: self.
	window :=  p open.
	window window
	   beUnresizeable ;
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]
