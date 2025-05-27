Class {
	#name : 'SearchableTablePresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
SearchableTablePresenterTest >> classToTest [  
  ^SearchableTablePresenter 
]

{ #category : 'running' }
SearchableTablePresenterTest >> setUp [ 
	super setUp.
	presenter := SearchableTablePresenter new.
	presenter initialize.
	presenter initializePresenters.
]

{ #category : 'tests' }
SearchableTablePresenterTest >> testApplyFilter [

	| records result columnSelector |
	records := {
	Dictionary newFromPairs: { #name -> 'Alpha'. #category -> 'Group 1' }.
	Dictionary newFromPairs: { #name -> 'Beta'.  #category -> 'Group 2' }.
	Dictionary newFromPairs: { #name -> 'Gamma'. #category -> 'Group 3' }
}.


	presenter columns: {
			('Name' -> #name).
			('Category' -> #category) }.

	presenter items: records.

	"Important: trigger filtering to populate columnSelector allItems"
	presenter applyFilter.

	columnSelector := presenter instVarNamed: 'columnSelector'.
	columnSelector selectedIndexes: #( 2 ). "select column 'Name'"

	presenter filterField text: 'mma'.
	presenter applyFilter.

	result := presenter filteredItems.

	self assert: result size equals: 1.
	self assert: (result first at: #name) equals: 'Gamma'
]

{ #category : 'tests' }
SearchableTablePresenterTest >> testColumns [ 
	presenter columns: {
		'Title' -> #title.
		'Author' -> #author }.
	self assert: (presenter filterField notNil).
	self assert: (presenter table notNil).
	self assert: ((presenter instVarNamed: 'labelToKey') keys includes: 'Title').
]

{ #category : 'tests' }
SearchableTablePresenterTest >> testColumnsPopulatesColumnSelectorAndLabelMap [

	| keys |
	presenter columns: {
			('Genre' -> #genre).
			('Year' -> #year) }.

	keys := (presenter instVarNamed: 'labelToKey') keys.
	self assert: keys asSet equals: #( 'Genre' 'Year' ) asSet.
	self
		assert: (presenter instVarNamed: 'columnSelector') allItems size
		equals: 2
]

{ #category : 'tests' }
SearchableTablePresenterTest >> testDisplayUsing [ 
	presenter displayUsing: [ :x | x asUppercase ].
	self assert: ((presenter instVarNamed: 'displayBlock') value: 'abc') equals: 'ABC'.
]

{ #category : 'tests' }
SearchableTablePresenterTest >> testFilteredItems [ 
	self assert: presenter filteredItems isCollection.
]

{ #category : 'tests' }
SearchableTablePresenterTest >> testHideSearchContainer [ 
	presenter hideSearchContainer.
	self deny: (presenter instVarNamed: 'isSearchable').
]

{ #category : 'tests' }
SearchableTablePresenterTest >> testItems [ 
	| items |
	items := { Dictionary newFromPairs: { #title -> 'A' } }.
	presenter columns: { 'Title' -> #title }.
	presenter items: items.
	self assert: presenter filteredItems equals: items asOrderedCollection.
]

{ #category : 'tests' }
SearchableTablePresenterTest >> testSelectedItem [ 
	| item |
	item := Dictionary newFromPairs: { #value -> 'Test' }.

	presenter columns: { 'Value' -> #value }.
	presenter items: { item }.

	presenter table selectItem: item.

	self assert: presenter selectedItem equals: item.

]

{ #category : 'tests' }
SearchableTablePresenterTest >> testShowSearchContainer [ 
	presenter instVarNamed: 'isSearchable' put: false.
	presenter showSearchContainer.
	self assert: (presenter instVarNamed: 'isSearchable').
]

{ #category : 'tests' }
SearchableTablePresenterTest >> testWhenSelectedItemChangedDo [ 
	| value item |
	value := nil.
	item := Dictionary newFromPairs: { #name -> 'ABC' }.

	presenter columns: { 'Name' -> #name }.
	presenter items: { item }.

	presenter whenSelectedItemChangedDo: [ :x | value := x ].
	presenter table selectItem: item.

	self assert: value equals: item.
]
