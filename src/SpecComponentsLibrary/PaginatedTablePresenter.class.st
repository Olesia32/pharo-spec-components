"
I am a paginated extension of `SearchableTablePresenter`.  
In addition to the built-in search and filtering capabilities, I provide UI and logic for navigating data across multiple pages.  
Users can switch pages, view the current and total page count, and jump directly to a specific page.  
Filtering resets pagination to the first page and displays filtered results accordingly.

### Hierarchy

`SpAbstractPresenter`  
  `SpPresenter`  
    `SearchableTablePresenter`  
      `PaginatedTablePresenter` (this is me)

### Instance Variables

- _currentPage_: an `Integer` — the number of the page currently displayed (1-based)
- _itemsPerPage_: an `Integer` — the number of items shown per page
- _paginationControls_: a `SpBoxLayout` — the layout containing page navigation buttons and page info
- _gotoPageInput_: a `TextInputPresenter` — input field to enter a specific page number
- _gotoPageButton_: a `ButtonPresenter` — button to trigger page jump from input

### Public API

- `PaginatedTablePresenter>>#itemsPerPage:` — sets the number of items per page
- `PaginatedTablePresenter>>#itemsPerPage` — returns the current item count per page
- `PaginatedTablePresenter>>#currentPage` — returns the current page number
- `PaginatedTablePresenter>>#totalPages` — returns the total number of pages
- `PaginatedTablePresenter>>#goToPage:` — jumps to the specified page number (if valid)
- `PaginatedTablePresenter>>#nextPage` / `PaginatedTablePresenter>>#previousPage` — navigates between pages
- `PaginatedTablePresenter>>#updateDisplayedItems` — refreshes the visible rows and pagination controls

### Usage

To use a paginated table, create an instance as with `SearchableTablePresenter`, but configure the page size as needed:

```smalltalk
| table |
table := PaginatedTablePresenter new.
table itemsPerPage: 10.
table columns: {
  'Title' -> #title.
  'Author' -> #author.
  'Genre' -> #genre }.
table items: {
  Dictionary newFromPairs: { #title -> '1984'. #author -> 'George Orwell'. #genre -> 'Dystopian' }.
  Dictionary newFromPairs: { #title -> 'To Kill a Mockingbird'. #author -> 'Harper Lee'. #genre -> 'Novel' }.
  Dictionary newFromPairs: { #title -> 'Brave New World'. #author -> 'Aldous Huxley'. #genre -> 'Science Fiction' } }.
table open.

"
Class {
	#name : 'PaginatedTablePresenter',
	#superclass : 'SearchableTablePresenter',
	#instVars : [
		'currentPage',
		'itemsPerPage',
		'paginationControls',
		'gotoPageInput',
		'gotoPageButton'
	],
	#category : 'SpecComponentsLibrary-Tables',
	#package : 'SpecComponentsLibrary',
	#tag : 'Tables'
}

{ #category : 'private' }
PaginatedTablePresenter >> applyFilter [
"Overrides the parent filter method.
Resets the current page to 1 before applying filtering and updating the pagination view."
	currentPage := 1.
	super applyFilter.
	self updatePagination
]

{ #category : 'accessing' }
PaginatedTablePresenter >> currentPage [
"Returns the current page number (1-based)."
	^ currentPage
]

{ #category : 'layout' }
PaginatedTablePresenter >> defaultLayout [

	| tmp1 tmp2 tmp3 |
	tmp2 := SpBoxLayout newVertical spacing: 10.
	isSearchable ifTrue: [
			tmp3 := SpBoxLayout newHorizontal.
			tmp3
				spacing: 5;
				add: searchField.
			tmp2 add: (tmp3 add: columnSelector) expand: false ].
	tmp2 add: tablePresenter.
	tmp1 := SpBoxLayout newVertical.
	tmp1
		spacing: 10;
		add: tmp2;
		add: paginationControls expand: false.
	^ tmp1 yourself
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> displayedItems [
"Returns the full range of items for the current page, without slicing them (used in non-paginated views)."
	| tmp1 tmp2 |
	tmp1 := currentPage - 1 * itemsPerPage + 1.
	tmp2 := tmp1 + itemsPerPage - 1 min: self filteredItems size.
	^ (tmp1 to: tmp2) collect: [ :arg1 |
		  self filteredItems at: arg1 ifAbsent: nil ]
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> goToPage: arg1 [
"Changes the current page to the given page number, if within valid bounds, and updates the pagination view."
	(arg1 between: 1 and: self totalPages) ifFalse: [ ^ self ].
	currentPage := arg1.
	self updatePagination
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> goToPageFromInput [
"Parses the text entered into the gotoPageInput field and jumps to the corresponding page if valid.
Clears the input after processing."
	| tmp1 tmp2 |
	tmp2 := gotoPageInput text asInteger.
	tmp1 := tmp2 ifNil: [ 1 ] ifNotNil: [ tmp2 ].
	gotoPageInput text: ''.
	self goToPage: tmp1
]

{ #category : 'initialization' }
PaginatedTablePresenter >> initializePresenters [

	super initializePresenters.
	currentPage := 1.
	itemsPerPage := 10.
	paginationControls := SpBoxLayout newLeftToRight.
	gotoPageInput := TextInputPresenter new.
	gotoPageButton := ButtonPresenter new.
	gotoPageButton
		label: 'Go';
		onClick: [ self goToPageFromInput ]
]

{ #category : 'accessing' }
PaginatedTablePresenter >> itemsPerPage [
"Gets the number of items to display per page."
	^ itemsPerPage
]

{ #category : 'accessing' }
PaginatedTablePresenter >> itemsPerPage: arg1 [
"Sets the number of items to display per page."
	itemsPerPage := arg1
]

{ #category : 'instance creation' }
PaginatedTablePresenter >> newPageButtonLabeled: arg1 action: arg2 [
"Creates and returns a ButtonPresenter with the given label and click action."
	| tmp1 |
	tmp1 := ButtonPresenter new.
	tmp1
		label: arg1;
		onClick: arg2.
	^ tmp1
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> nextPage [
"Navigates to the next page, staying within valid limits."
	self goToPage: (currentPage + 1 min: self totalPages)
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> paginatedItems [
"Returns the subcollection of filtered items that belong to the current page."
	| tmp1 tmp2 |
	tmp1 := currentPage - 1 * itemsPerPage + 1.
	tmp2 := tmp1 + itemsPerPage - 1 min: self filteredItems size.
	^ (tmp1 to: tmp2) collect: [ :arg1 |
		  self filteredItems at: arg1 ifAbsent: nil ]
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> previousPage [
"Navigates to the previous page, staying within valid limits."
	self goToPage: (currentPage - 1 max: 1)
]

{ #category : 'accessing' }
PaginatedTablePresenter >> totalPages [
"Calculates the number of total pages based on the filtered item count and itemsPerPage."
	^ (self filteredItems size / itemsPerPage) ceiling max: 1
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> updateDisplayedItems [
"Updates the table to show all items on the current page (via displayedItems) and refreshes pagination controls."
	tablePresenter items: self displayedItems.
	self updatePaginationControls
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> updatePagination [
"Same as updateDisplayedItems, but uses paginatedItems to slice filtered results."
	tablePresenter items: self paginatedItems.
	self updatePaginationControls
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> updatePaginationControls [
"Rebuilds the pagination controls layout.
Includes page buttons, ellipsis markers, current page info, and the Go-to-Page input."
	paginationControls
		removeAll;
		add: (self newPageButtonLabeled: '←' action: [ self previousPage ])
		expand: false.

	self visiblePageNumbers do: [ :arg1 |
			| tmp1 tmp2 |
			arg1 = #'...'
				ifTrue: [
						tmp1 := ButtonPresenter new.
						tmp1
							label: '...';
							fontSize: 14.
						tmp1 mainPresenter enabled: false.
						paginationControls add: tmp1 ]
				ifFalse: [
						tmp2 := ButtonPresenter new.
						tmp2
							label: arg1 asString;
							onClick: [ self goToPage: arg1 ].
						arg1 = currentPage ifTrue: [
								tmp2 bold.
								tmp2 backgroundColor: '#lightGray' ].
						paginationControls add: tmp2 withConstraints: [ :arg2 |
								arg2
									width: 30;
									expand: false ] ] ].

	paginationControls
		add: (self newPageButtonLabeled: '→' action: [ self nextPage ])
		expand: false;
		add: (LabelPresenter new text:
					 currentPage asString , ' / ' , self totalPages asString)
		withConstraints: [ :arg3 | arg3 padding: 15 ];
		add: gotoPageInput withConstraints: [ :arg4 |
				arg4
					width: 40;
					expand: false ];
		add: gotoPageButton
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> visiblePageNumbers [
"Returns a sequence of page numbers and ellipsis (#'...') symbols for rendering compact pagination."
	| tmp1 |
	tmp1 := self totalPages.
	tmp1 <= 5 ifTrue: [ ^ (1 to: tmp1) asOrderedCollection ].
	nil.
	currentPage <= 4 ifTrue: [ ^ #( 1 2 3 4 #'...' ) , { tmp1 } ].
	nil.
	currentPage >= (tmp1 - 3) ifTrue: [
		^ { 1 } , #( #'...' ) , (tmp1 - 3 to: tmp1) asOrderedCollection ].
	nil.
	^ { 1 } , #( #'...' )
	  , (currentPage - 1 to: currentPage + 1) asOrderedCollection
	  , #( #'...' ) , { tmp1 }
]
