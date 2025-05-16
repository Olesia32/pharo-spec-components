"
Компонент для відображення таблиці з можливістю пошуку і фільтрації по колонках.

Підтримує пошукове поле, вибір колонок, що фільтруються, і динамічну зміну списку елементів.

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

	| tmp1 tmp2 |
	tmp1 := searchField text asLowercase.
	tmp2 := columnSelector selectedItems collect: [ :arg1 |
		        labelToKey at: arg1 ifAbsent: nil ].
	filteredItems := allItems select: [ :arg2 |
			                 tmp2 anySatisfy: [ :arg3 |
					                 (arg2 at: arg3 ifAbsent: '') asString
						                 asLowercase includesSubstring: tmp1 ] ].
	tablePresenter items: filteredItems
]

{ #category : 'api' }
SearchableTablePresenter >> columns: arg1 [

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
    displayBlock := aBlock
]

{ #category : 'private' }
SearchableTablePresenter >> filterComboBox [
   ^ columnSelector 
]

{ #category : 'accessing' }
SearchableTablePresenter >> filterField [ 
^ searchField 
]

{ #category : 'accessing' }
SearchableTablePresenter >> filteredItems [

	^ filteredItems
]

{ #category : 'accessing' }
SearchableTablePresenter >> hideSearchContainer [

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

	allItems := aCollection asOrderedCollection.
	self applyFilter
]

{ #category : 'accessing' }
SearchableTablePresenter >> selectedItem [ 
    ^ tablePresenter selectedItem
]

{ #category : 'accessing' }
SearchableTablePresenter >> showSearchContainer [

	isSearchable := true.
	self defaultLayout
]

{ #category : 'accessing' }
SearchableTablePresenter >> table [
^ tablePresenter 
]

{ #category : 'events' }
SearchableTablePresenter >> whenSelectedItemChangedDo: aBlock [ 
    tablePresenter whenSelectedItemChangedDo: aBlock
]
