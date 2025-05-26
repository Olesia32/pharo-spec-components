"
I am a domain model representing an application user in the BookTracker system.

I store authentication credentials and am used for login validation and account management.

### Instance Variables

- _username_ — the login name of the user.
- _password_ — the user's password.

### Responsibilities

- Hold login credentials.
- Support simple access and mutation via standard accessors.
"
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
