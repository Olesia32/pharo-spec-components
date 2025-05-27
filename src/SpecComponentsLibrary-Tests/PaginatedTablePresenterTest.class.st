Class {
	#name : 'PaginatedTablePresenterTest',
	#superclass : 'SearchableTablePresenterTest',
	#instVars : [
		'sampleItems'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
PaginatedTablePresenterTest >> classToTest [ 
  ^ PaginatedTablePresenter 
]

{ #category : 'running' }
PaginatedTablePresenterTest >> setUp [ 
	super setUp.
	presenter := PaginatedTablePresenter new.
	sampleItems := (1 to: 25) collect: [ :i |
		Dictionary newFromPairs: { #title -> ('Book ', i asString) } ].
	presenter columns: { 'Title' -> #title }.
	presenter items: sampleItems.
	presenter itemsPerPage: 10.
	presenter updatePagination.
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testApplyFilter [

	presenter goToPage: 2.
	(presenter instVarNamed: 'searchField') text: 'Book 1'. "matches Book 1, Book 10..19"
	presenter applyFilter.
	self assert: presenter currentPage equals: 1.
	self assert: presenter totalPages equals: 2
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testCurrentPage [
	self assert: presenter currentPage equals: 1
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testGoToPage [

	presenter goToPage: 3.
	self assert: presenter currentPage equals: 3.
	
   presenter goToPage: 99.
	self assert: presenter currentPage equals: 3.
	presenter goToPage: 0.
	self assert: presenter currentPage equals: 3
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testGoToPageFromInput [

	(presenter instVarNamed: 'gotoPageInput') text: '2'.
	presenter goToPageFromInput.
	self assert: presenter currentPage equals: 2.
	self assert: (presenter instVarNamed: 'gotoPageInput') text isEmpty.
	
   (presenter instVarNamed: 'gotoPageInput') text: '999'.
	presenter goToPageFromInput.
	self assert: presenter currentPage equals: 2.
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenterTest >> testItemsPerPage [ 

	presenter itemsPerPage: 5.
	self assert: presenter totalPages equals: 5.
	presenter itemsPerPage: 25.
	self assert: presenter totalPages equals: 1
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testNextPage [
	presenter nextPage.
	self assert: presenter currentPage equals: 2
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testPaginatedItems [

	| titles |
	presenter goToPage: 2.
	titles := presenter paginatedItems.
	self assert: titles first equals: 'Book 11'.
	self assert: titles last equals: 'Book 20'
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testPreviousPage [
	presenter nextPage.
	presenter previousPage.
	self assert: presenter currentPage equals: 1
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testTotalPages [
	self assert: presenter totalPages equals: 3.
	presenter itemsPerPage: 7.
	self assert: presenter totalPages equals: 4
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testUpdateDisplayedItems [

	presenter goToPage: 2.
	presenter updateDisplayedItems.
	self
		assert: (presenter table items first at: #title)
		equals: 'Book 11'
]

{ #category : 'tests' }
PaginatedTablePresenterTest >> testVisiblePageNumbers [

	presenter itemsPerPage: 25.
	presenter updatePagination.
	self assert: presenter visiblePageNumbers asArray equals: #( 1 ).

	presenter itemsPerPage: 2.
	presenter updatePagination.
	presenter goToPage: 1.
	self
		assert: presenter visiblePageNumbers asArray
		equals: #( 1 2 3 4 #'...' 13 ).
		
   presenter updatePagination.
	presenter goToPage: 7.
	self assert: presenter visiblePageNumbers asArray
		equals: #(1 #'...' 6 7 8 #'...' 13).
		
presenter updatePagination.
	presenter goToPage: 13.
	self assert: presenter visiblePageNumbers asArray
		equals: #(1 #'...' 10 11 12 13).
]
