Class {
	#name : 'User',
	#superclass : 'Object',
	#instVars : [
		'username',
		'password'
	],
	#category : 'SpecComponentsLibrary-Examples-BookTracker',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'BookTracker'
}

{ #category : 'accessing' }
User >> password [

	^ password
]

{ #category : 'accessing' }
User >> password: anObject [

	password := anObject
]

{ #category : 'accessing' }
User >> username [

	^ username
]

{ #category : 'accessing' }
User >> username: anObject [

	username := anObject
]
