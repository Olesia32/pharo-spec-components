"
I am a domain model representing a book associated with a user in the BookTracker system.

I store information about a book added by a user, including metadata, rating, personal impression, and date of entry.

### Instance Variables

- _id_ — the unique identifier of the book entry.
- _username_ — the name of the user who added the book.
- _title_ — the book’s title.
- _author_ — the book’s author.
- _genre_ — the literary genre.
- _year_ — the year of publication.
- _rating_ — the user’s rating (e.g. from 1 to 10).
- _impression_ — the user's personal comments about the book.
- _dateAdded_ — the timestamp when the book was added.

### Responsibilities

- Hold structured book information tied to a user.
- Provide access to all relevant metadata and user-generated input.
"
Class {
	#name : 'UserBook',
	#superclass : 'Object',
	#instVars : [
		'id',
		'username',
		'title',
		'author',
		'genre',
		'year',
		'rating',
		'impression',
		'dateAdded'
	],
	#category : 'SpecComponentsLibrary-Examples-BookTracker',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'BookTracker'
}

{ #category : 'accessing' }
UserBook >> author [

	^ author
]

{ #category : 'accessing' }
UserBook >> author: anObject [

	author := anObject
]

{ #category : 'accessing' }
UserBook >> dateAdded [

	^ dateAdded
]

{ #category : 'accessing' }
UserBook >> dateAdded: anObject [

	dateAdded := anObject
]

{ #category : 'accessing' }
UserBook >> genre [

	^ genre
]

{ #category : 'accessing' }
UserBook >> genre: anObject [

	genre := anObject
]

{ #category : 'accessing' }
UserBook >> id [

	^ id
]

{ #category : 'accessing' }
UserBook >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
UserBook >> impression [

	^ impression
]

{ #category : 'accessing' }
UserBook >> impression: anObject [

	impression := anObject
]

{ #category : 'accessing' }
UserBook >> rating [

	^ rating
]

{ #category : 'accessing' }
UserBook >> rating: anObject [

	rating := anObject
]

{ #category : 'accessing' }
UserBook >> title [

	^ title
]

{ #category : 'accessing' }
UserBook >> title: anObject [

	title := anObject
]

{ #category : 'accessing' }
UserBook >> username [

	^ username
]

{ #category : 'accessing' }
UserBook >> username: anObject [

	username := anObject
]

{ #category : 'accessing' }
UserBook >> year [

	^ year
]

{ #category : 'accessing' }
UserBook >> year: anObject [

	year := anObject
]
