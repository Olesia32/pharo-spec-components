Class {
	#name : 'User',
	#superclass : 'Object',
	#instVars : [
		'username',
		'password'
	],
	#category : 'SpecComponentsLibrary-Examples',
	#package : 'SpecComponentsLibrary',
	#tag : 'Examples'
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
