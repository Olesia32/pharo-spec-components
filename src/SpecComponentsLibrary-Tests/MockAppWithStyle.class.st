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
