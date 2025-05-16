Class {
	#name : 'BookTrackerDescriptorSystem',
	#superclass : 'DescriptorSystem',
	#instVars : [
		'mainPresenter'
	],
	#category : 'SpecComponentsLibrary-Examples',
	#package : 'SpecComponentsLibrary',
	#tag : 'Examples'
}

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> classModelForUser: aClassModel [ 
	(aClassModel newAttributeNamed: #username) useDirectAccess: true.
	aClassModel newAttributeNamed: #password.
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> classModelForUserBook: aClassModel [ 
	(aClassModel newAttributeNamed: #id) useDirectAccess: true.
	aClassModel newAttributeNamed: #username.
	aClassModel newAttributeNamed: #title.
	aClassModel newAttributeNamed: #author.
	aClassModel newAttributeNamed: #genre.
	aClassModel newAttributeNamed: #year.
	aClassModel newAttributeNamed: #rating.
	aClassModel newAttributeNamed: #impression.
	aClassModel newAttributeNamed: #dateAdded.
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> descriptorForUser: aDescriptor [ 
	| table |
	table := self tableNamed: 'USERS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #username to: (table fieldNamed: 'username').
	(aDescriptor newMapping: DirectMapping) from: #password to: (table fieldNamed: 'password').
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> descriptorForUserBook: aDescriptor [ 
	| table |
	table := self tableNamed: 'USER_BOOKS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'id').
	(aDescriptor newMapping: DirectMapping) from: #username to: (table fieldNamed: 'username').
	(aDescriptor newMapping: DirectMapping) from: #title to: (table fieldNamed: 'title').
	(aDescriptor newMapping: DirectMapping) from: #author to: (table fieldNamed: 'author').
	(aDescriptor newMapping: DirectMapping) from: #genre to: (table fieldNamed: 'genre').
	(aDescriptor newMapping: DirectMapping) from: #year to: (table fieldNamed: 'year').
	(aDescriptor newMapping: DirectMapping) from: #rating to: (table fieldNamed: 'rating').
	(aDescriptor newMapping: DirectMapping) from: #impression to: (table fieldNamed: 'impression').
	(aDescriptor newMapping: DirectMapping) from: #dateAdded to: (table fieldNamed: 'dateAdded').
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> tableForUSERS: aTable [ 
	(aTable createFieldNamed: 'username' type: (platform varChar: 100)) bePrimaryKey.
	aTable createFieldNamed: 'password' type: (platform varChar: 100).
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> tableForUSER_BOOKS: aTable [ 
   | userField |
	(aTable createFieldNamed: 'id' type: platform serial) bePrimaryKey.
	userField := aTable createFieldNamed: 'username' type: (platform varChar: 100).
	aTable
		addForeignKeyFrom: userField
		to: ((self tableNamed: 'USERS') fieldNamed: 'username').
	aTable createFieldNamed: 'title' type: (platform varChar: 200).
	aTable createFieldNamed: 'author' type: (platform varChar: 200).
	aTable createFieldNamed: 'genre' type: (platform varChar: 100).
	aTable createFieldNamed: 'year' type: platform integer.
	aTable createFieldNamed: 'rating' type: platform integer.
	aTable createFieldNamed: 'impression' type: (platform varChar: 500).
	aTable createFieldNamed: 'dateAdded' type: platform timestamp.
]
