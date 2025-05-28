"
I am a lightweight mock application used in unit tests for styled presenters.  
I simulate the basic API of a real Spec 2 application that supports styles.

I provide access to a `styleSheet` object (typically an instance of `SpClassStyle`)  
and implement the `configuration` message, returning self, as expected by style-related logic  
in `BasePresenter`, `StyleManager`, and similar components.""

"
Class {
	#name : 'MockAppWithStyle',
	#superclass : 'Object',
	#instVars : [
		'styleSheet'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
MockAppWithStyle >> configuration [
    ^ self.
]

{ #category : 'as yet unclassified' }
MockAppWithStyle >> styleSheet [

	^ styleSheet ifNil: [ styleSheet := SpClassStyle new ]
]
