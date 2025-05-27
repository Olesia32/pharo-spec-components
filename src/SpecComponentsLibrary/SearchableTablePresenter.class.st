"
I am a table presenter with built-in search and filtering support.  
I provide a search field and a multi-select dropdown to choose which columns to filter.  
The list of visible items in the table updates dynamically as the user types or adjusts the column selection.
The ability to hide the search block is designed for subclasses like `PaginatedTablePresenter`, where search visibility can be toggled dynamically.

### Instance Variables

- _searchField_: a `TextInputPresenter` — text field for entering the search query
- _tablePresenter_: a `SpTablePresenter` — the table displaying filtered items
- _allItems_: an `OrderedCollection` — the full dataset backing the table
- _displayBlock_: a `BlockClosure` — transforms a data object into its display representation
- _columnSelector_: a `MultiSelectComboBoxPresenter` — dropdown to choose which columns participate in filtering
- _labelToKey_: a `Dictionary` — maps human-readable column labels to internal keys
- _filteredItems_: an `OrderedCollection` — the filtered subset shown in the table
- _isSearchable_: a `Boolean` — indicates whether the search UI is shown

### Public API

- `SearchableTablePresenter>>#items:` — sets the full item collection and triggers filtering
- `SearchableTablePresenter>>#columns:` — sets the column definitions and populates the column selector
- `SearchableTablePresenter>>#displayUsing:` — sets a custom display transformation block
- `SearchableTablePresenter>>#selectedItem` — returns the currently selected table row
- `SearchableTablePresenter>>#showSearchContainer` / `SearchableTablePresenter>>#hideSearchContainer` — controls the visibility of the search field and column selector
- `SearchableTablePresenter>>#table` — returns the underlying `SpTablePresenter`
- `SearchableTablePresenter>>#filterField` — returns the search input field
- `SearchableTablePresenter>>#filteredItems` — returns the current result of filtering

### Events

- `SearchableTablePresenter>>#whenSelectedItemChangedDo:` — registers a callback that is triggered when a table row is selected

### Usage

To use a searchable table, specify the columns and items. Filtering will be applied automatically based on user input:

```smalltalk
| table |
table := SearchableTablePresenter new.
table columns: {
  'Title' -> #title.
  'Author' -> #author.
  'Genre' -> #genre }.
table items: {
  Dictionary newFromPairs: { #title -> '1984'. #author -> 'George Orwell'. #genre -> 'Dystopian' }.
  Dictionary newFromPairs: { #title -> 'To Kill a Mockingbird'. #author -> 'Harper Lee'. #genre -> 'Novel' } }.
table open.


"
Class {
	#name : 'SearchableTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'searchField',
		'tablePresenter',
		'allItems',
		'displayBlock',
		'columnSelector',
		'labelToKey',
		'filteredItems',
		'isSearchable'
	],
	#category : 'SpecComponentsLibrary-Tables',
	#package : 'SpecComponentsLibrary',
	#tag : 'Tables'
}

{ #category : 'private' }
SearchableTablePresenter >> applyFilter [
	"Applies the current search query to the list of items.
Only rows that match the search string in at least one of the selected columns will remain visible."

	| tmp1 tmp2 |
	tmp1 := searchField text asLowercase.
	tmp2 := columnSelector selectedItems collect: [ :arg1 |
		        labelToKey at: arg1 ifAbsent: nil ].
	filteredItems := allItems select: [ :row |
			                 tmp2 anySatisfy: [ :key |
					                 (row at: key ifAbsent: '') asString asLowercase
						                 includesSubstring: tmp1 ] ].
	tablePresenter items: filteredItems
]

{ #category : 'api' }
SearchableTablePresenter >> columns: arg1 [
"Defines the columns of the table.
Accepts a collection of pairs Label -> Key.
These keys are used both for display and filtering, and labels populate the column selector."
	| tmp1 |
	labelToKey := Dictionary new.
	tmp1 := arg1 collect: [ :arg2 |
			        | tmp2 |
			        tmp2 := SpStringTableColumn new.
			        tmp2
				        title: arg2 key asString;
				        evaluated: [ :arg3 | arg3 at: arg2 value ifAbsent: '' ];
				        beSortable;
				        yourself ].
	tablePresenter columns: tmp1.
	arg1 do: [ :arg4 | labelToKey at: arg4 key asString put: arg4 value ].
	columnSelector
		items: labelToKey keys;
		selectedIndexes: (1 to: columnSelector allItems size).
	self applyFilter
]

{ #category : 'initialization' }
SearchableTablePresenter >> connectPresenters [
"Connects the search field and column selector to the filter logic.
Filtering is applied automatically on text change or column selection change."
	searchField mainPresenter whenTextChangedDo: [ self applyFilter ].
	columnSelector whenSelectionChangedDo: [ :arg1 | self applyFilter ]
]

{ #category : 'layout' }
SearchableTablePresenter >> defaultLayout [

	| tmp1 tmp2 |
	tmp1 := SpBoxLayout newVertical spacing: 10.
	isSearchable ifTrue: [
			tmp2 := SpBoxLayout newHorizontal.
			tmp2
				spacing: 5;
				add: searchField.
			tmp1 add: (tmp2 add: columnSelector) expand: false ].
	tmp1 add: tablePresenter.
	^ tmp1 yourself
]

{ #category : 'accessing' }
SearchableTablePresenter >> displayUsing: aBlock [
"Sets a custom block for converting an item into a displayable object.
Useful for adapting raw data structures."
	displayBlock := aBlock
]

{ #category : 'accessing' }
SearchableTablePresenter >> filterField [
"Returns the search input field (TextInputPresenter)."
	^ searchField
]

{ #category : 'accessing' }
SearchableTablePresenter >> filteredItems [
"Returns the currently visible items after filtering is applied."
	^ filteredItems
]

{ #category : 'accessing' }
SearchableTablePresenter >> hideSearchContainer [
"Hides the search field and column selector from the layout.
Does not remove filtering logic."
	isSearchable := false.
	self defaultLayout
]

{ #category : 'initialization' }
SearchableTablePresenter >> initialize [
super initialize.
	allItems := #(  ).
	filteredItems := #(  ).
	isSearchable := true.
]

{ #category : 'initialization' }
SearchableTablePresenter >> initializePresenters [

	searchField := TextInputPresenter new.
	tablePresenter := SpTablePresenter new.
	columnSelector := MultiSelectComboBoxPresenter new.
	displayBlock := [ :arg1 | arg1 ].
	self focusOrder addAll: {
			searchField.
			tablePresenter }
]

{ #category : 'api' }
SearchableTablePresenter >> items: aCollection [
"Sets the full collection of items to display.
Triggers filtering immediately."
	allItems := aCollection asOrderedCollection.
	self applyFilter
]

{ #category : 'accessing' }
SearchableTablePresenter >> selectedItem [
"Returns the item currently selected in the table."
	^ tablePresenter selectedItem
]

{ #category : 'accessing' }
SearchableTablePresenter >> showSearchContainer [
"Makes the search field and column selector visible again and updates the layout."
	isSearchable := true.
	self defaultLayout
]

{ #category : 'accessing' }
SearchableTablePresenter >> table [
"Returns the internal table presenter."
	^ tablePresenter
]

{ #category : 'events' }
SearchableTablePresenter >> whenSelectedItemChangedDo: aBlock [
"Registers a callback to be triggered when a user selects a different row in the table."
	tablePresenter whenSelectedItemChangedDo: aBlock
]
