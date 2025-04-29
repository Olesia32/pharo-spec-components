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

	super initialize
]

{ #category : 'initialization' }
TestApp >> start [ 
| window |
	window := (self newPresenter: TestPresenter ) open.
	window window
		beUnresizeable;
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox

]
