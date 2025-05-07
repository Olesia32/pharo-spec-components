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
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'private' }
PaginatedTablePresenter >> applyFilter [

	currentPage := 1.
	super applyFilter.
	self updatePagination
]

{ #category : 'accessing' }
PaginatedTablePresenter >> currentPage [

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

	| tmp1 tmp2 |
	tmp1 := currentPage - 1 * itemsPerPage + 1.
	tmp2 := tmp1 + itemsPerPage - 1 min: self filteredItems size.
	^ (tmp1 to: tmp2) collect: [ :arg1 |
		  self filteredItems at: arg1 ifAbsent: nil ]
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> goToPage: arg1 [

	(arg1 between: 1 and: self totalPages) ifFalse: [ ^ self ].
	currentPage := arg1.
	self updatePagination
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> goToPageFromInput [

	| tmp1 tmp2 |
	tmp2 := gotoPageInput text asInteger.
	tmp1 := tmp2 ifNil: [ 1 ] ifNotNil: [ tmp2 ].
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

	^ itemsPerPage
]

{ #category : 'accessing' }
PaginatedTablePresenter >> itemsPerPage: arg1 [

	itemsPerPage := arg1
]

{ #category : 'instance creation' }
PaginatedTablePresenter >> newPageButtonLabeled: arg1 action: arg2 [

	| tmp1 |
	tmp1 := ButtonPresenter new.
	tmp1
		label: arg1;
		onClick: arg2.
	^ tmp1
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> nextPage [

	self goToPage: (currentPage + 1 min: self totalPages)
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> paginatedItems [

	| tmp1 tmp2 |
	tmp1 := currentPage - 1 * itemsPerPage + 1.
	tmp2 := tmp1 + itemsPerPage - 1 min: self filteredItems size.
	^ (tmp1 to: tmp2) collect: [ :arg1 |
		  self filteredItems at: arg1 ifAbsent: nil ]
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> previousPage [

	self goToPage: (currentPage - 1 max: 1)
]

{ #category : 'accessing' }
PaginatedTablePresenter >> totalPages [

	^ (self filteredItems size / itemsPerPage) ceiling max: 1
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> updateDisplayedItems [

	tablePresenter items: self displayedItems.
	self updatePaginationControls
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> updatePagination [

	tablePresenter items: self paginatedItems.
	self updatePaginationControls
]

{ #category : 'as yet unclassified' }
PaginatedTablePresenter >> updatePaginationControls [

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
						arg1 = currentPage ifTrue: [ tmp2 bold ].
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

	| tmp1 |
	tmp1 := self totalPages.
	tmp1 <= 7 ifTrue: [ ^ (1 to: tmp1) asOrderedCollection ].
	nil.
	currentPage <= 4 ifTrue: [
		^ #( 1 2 3 4 5 #'.' #'.' #'.' ) , { tmp1 } ].
	nil.
	currentPage >= tmp1 - 3 ifTrue: [
			^ { 1 } , #( #'.' #'.' #'.' )
			  , (tmp1 - 4 to: tmp1) asOrderedCollection ].
	nil.
	^ { 1 } , #( #'.' #'.' #'.' )
	  , (currentPage - 1 to: currentPage + 1) asOrderedCollection
	  , #( #'.' #'.' #'.' ) , { tmp1 }
]
