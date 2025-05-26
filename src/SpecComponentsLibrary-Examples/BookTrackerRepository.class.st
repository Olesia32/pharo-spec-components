"
I am the data access layer for the BookTracker application.

I encapsulate all interactions with the Glorp persistence framework and PostgreSQL database. I provide methods to query, add, update, and delete `User` and `UserBook` records. I initialize the session and descriptor system used for object-relational mapping.

### Instance Variables

- _currentSession_ — the active Glorp session used to perform database operations.

### Responsibilities

- Connect to a PostgreSQL database and initialize the persistence layer.
- Manage users and their books through `add`, `read`, `update`, and `delete` operations.
- Provide methods for authentication and book retrieval.
- Create database tables when needed.
"
Class {
	#name : 'BookTrackerRepository',
	#superclass : 'Object',
	#instVars : [
		'currentSession'
	],
	#category : 'SpecComponentsLibrary-Examples-BookTracker',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'BookTracker'
}

{ #category : 'adding' }
BookTrackerRepository >> addBook: aBook [ 
	currentSession inUnitOfWorkDo: [
		currentSession register: aBook
	].
	^ aBook id
]

{ #category : 'adding' }
BookTrackerRepository >> addUser: aUser [ 
	currentSession inUnitOfWorkDo: [
		currentSession register: aUser]
]

{ #category : 'table creation' }
BookTrackerRepository >> createTables [ 
	currentSession createTables
]

{ #category : 'adding' }
BookTrackerRepository >> deleteBook: aBook [ 
	currentSession inUnitOfWorkDo: [
		currentSession delete: aBook]
]

{ #category : 'as yet unclassified' }
BookTrackerRepository >> getBookById: anId [ 
	| result |
	result := currentSession read: UserBook where: [ :each | each id = anId ].
	^ result isEmpty ifTrue: [ nil ] ifFalse: [ result first ]
]

{ #category : 'adding' }
BookTrackerRepository >> getBooksForUser: aLogin [ 
	^ currentSession read: UserBook where: [ :each | each username = aLogin ]
]

{ #category : 'adding' }
BookTrackerRepository >> getUserByLogin: aLogin [ 
	| user |
	user := currentSession read: User where: [ :each | each username = aLogin ].
	^ user isEmpty ifTrue: [ nil ] ifFalse: [ user first ]
]

{ #category : 'initialization' }
BookTrackerRepository >> initialize [

	| login accessor session |
	login := Login new
		         database: PostgreSQLPlatform new;
		         username: 'postgres';
		         password: '';
		         host: 'localhost';
		         port: '5432';
		         databaseName: 'BookTrackerDB'.

	accessor := DatabaseAccessor forLogin: login.
	accessor login.

	session := GlorpSession new.
	session system:
		(BookTrackerDescriptorSystem forPlatform: login database).
	session accessor: accessor.
	currentSession := session
]

{ #category : 'as yet unclassified' }
BookTrackerRepository >> updateBook: arg1 [

	currentSession inUnitOfWorkDo: [
			| tmp1 |
			tmp1 := currentSession
				        readOneOf:
					        ('<an unprintable nonliteral value>'
						         runtimeUndeclaredReadInContext: thisContext)
				        where: [ :arg2 | arg2 id = arg1 id ].
			tmp1
				title: arg1 title;
				author: arg1 author;
				genre: arg1 genre;
				year: arg1 year;
				rating: arg1 rating;
				impression: arg1 impression;
				dateAdded: arg1 dateAdded ]
]
