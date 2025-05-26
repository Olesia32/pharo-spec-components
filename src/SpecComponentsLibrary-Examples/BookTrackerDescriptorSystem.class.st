"
I am the descriptor system for the BookTracker application.

I define how domain objects like `User` and `UserBook` are represented in the database. I configure object-relational mappings using Glorp, specifying class models, descriptors, and table schemas. My purpose is to support persistence and retrieval of application data.

### Responsibilities

- Define class models for domain entities.
- Map object fields to relational table columns using direct mappings.
- Declare primary keys and foreign key constraints.
- Provide table schemas for users and their books.
"
Class {
	#name : 'BookTrackerDescriptorSystem',
	#superclass : 'DescriptorSystem',
	#category : 'SpecComponentsLibrary-Examples-BookTracker',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'BookTracker'
}

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> classModelForUser: arg1 [

	(arg1 newAttributeNamed: #username) useDirectAccess: true.
	arg1 newAttributeNamed: #password
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> classModelForUserBook: arg1 [

	(arg1 newAttributeNamed: #id) useDirectAccess: true.
	arg1
		newAttributeNamed: #username;
		newAttributeNamed: #title;
		newAttributeNamed: #author;
		newAttributeNamed: #genre;
		newAttributeNamed: #year;
		newAttributeNamed: #rating;
		newAttributeNamed: #impression;
		newAttributeNamed: #dateAdded
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> descriptorForUser: arg1 [

	| tmp1 |
	tmp1 := self tableNamed: 'USERS'.
	arg1 table: tmp1.
	(arg1 newMapping: DirectMapping)
		from: #username to: (tmp1 fieldNamed: 'username');
		from: #password to: (tmp1 fieldNamed: 'password')
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> descriptorForUserBook: arg1 [

	| tmp1 |
	tmp1 := self tableNamed: 'USER_BOOKS'.
	arg1 table: tmp1.
	(arg1 newMapping: DirectMapping)
		from: #id to: (tmp1 fieldNamed: 'id');
		from: #username to: (tmp1 fieldNamed: 'username');
		from: #title to: (tmp1 fieldNamed: 'title');
		from: #author to: (tmp1 fieldNamed: 'author');
		from: #genre to: (tmp1 fieldNamed: 'genre');
		from: #year to: (tmp1 fieldNamed: 'year');
		from: #rating to: (tmp1 fieldNamed: 'rating');
		from: #impression to: (tmp1 fieldNamed: 'impression');
		from: #dateAdded to: (tmp1 fieldNamed: 'dateAdded')
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> tableForUSERS: arg1 [

	(arg1 createFieldNamed: 'username' type: (platform varChar: 100))
		bePrimaryKey.
	arg1 createFieldNamed: 'password' type: (platform varChar: 100)
]

{ #category : 'as yet unclassified' }
BookTrackerDescriptorSystem >> tableForUSER_BOOKS: arg1 [

	| tmp1 |
	(arg1 createFieldNamed: 'id' type: platform serial) bePrimaryKey.
	tmp1 := arg1
		        createFieldNamed: 'username'
		        type: (platform varChar: 100).
	arg1
		addForeignKeyFrom: tmp1
		to: ((self tableNamed: 'USERS') fieldNamed: 'username');
		createFieldNamed: 'title' type: (platform varChar: 200);
		createFieldNamed: 'author' type: (platform varChar: 200);
		createFieldNamed: 'genre' type: (platform varChar: 100);
		createFieldNamed: 'year' type: platform integer;
		createFieldNamed: 'rating' type: platform integer;
		createFieldNamed: 'impression' type: (platform varChar: 500);
		createFieldNamed: 'dateAdded' type: platform timestamp
]
