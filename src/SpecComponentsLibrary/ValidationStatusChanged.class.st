Class {
	#name : 'ValidationStatusChanged',
	#superclass : 'Announcement',
	#instVars : [
		'newValue'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
ValidationStatusChanged >> newValue [ 
    ^ newValue
]

{ #category : 'accessing' }
ValidationStatusChanged >> newValue: aValue [ 
    newValue := aValue
]
