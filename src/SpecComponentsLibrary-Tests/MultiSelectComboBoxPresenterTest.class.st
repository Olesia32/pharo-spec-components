Class {
	#name : 'MultiSelectComboBoxPresenterTest',
	#superclass : 'AbstractDropdownPresenterTest',
	#instVars : [
		'announcedSelection'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
MultiSelectComboBoxPresenterTest >> classToTest [ 
  ^ MultiSelectComboBoxPresenter 
]

{ #category : 'running' }
MultiSelectComboBoxPresenterTest >> setUp [

	super setUp.
	presenter := MultiSelectComboBoxPresenter new.
	presenter initialize.
	presenter items: #( 'Apple' 'Banana' 'Orange' ).
	presenter build.
	announcedSelection := nil
]

{ #category : 'tests' }
MultiSelectComboBoxPresenterTest >> testAllItems [

	self
		assert: presenter allItems
		equals: #( 'Apple' 'Banana' 'Orange' )
]

{ #category : 'tests' }
MultiSelectComboBoxPresenterTest >> testClearSelection [

	presenter selectedIndexes: #( 1 2 ).
	presenter selectedItems removeAll.
	self assert: presenter selectedItems isEmpty
]

{ #category : 'tests' }
MultiSelectComboBoxPresenterTest >> testFilterList [

	presenter textInput text: 'an'.
	presenter filterList.
	self assert: presenter filteredItems equals: #( 'Banana' 'Orange' )
]

{ #category : 'tests' }
MultiSelectComboBoxPresenterTest >> testSelectedIndexes [

	presenter selectedIndexes: #( 1 3 ).
	self
		assert: presenter selectedItems asSet
		equals: #( 'Apple' 'Orange' ) asSet
]

{ #category : 'tests' }
MultiSelectComboBoxPresenterTest >> testSelectedIndexesIgnoresInvalidIndices [ 
	presenter items: #('A' 'B').
	presenter selectedIndexes: #(2 99).
	self assert: presenter selectedItems asArray equals: #('B').
]

{ #category : 'accessing' }
MultiSelectComboBoxPresenterTest >> testSelectedItems [

	presenter selectedIndexes: #( 1 3 ).
	self
		assert: presenter selectedItems asSet
		equals: #( 'Apple' 'Orange' ) asSet
]

{ #category : 'tests' }
MultiSelectComboBoxPresenterTest >> testUpdateFieldContent [

	presenter selectedIndexes: #( 1 2 ).
	presenter toggleList. "Open"
	presenter toggleList. "Close"
	self assert: presenter textInput text equals: 'Apple, Banana'
]

{ #category : 'tests' }
MultiSelectComboBoxPresenterTest >> testWhenSelectionChangedDo [

	presenter whenSelectionChangedDo: [ :sel | announcedSelection := sel ].
	presenter selectedIndexes: #( 2 ).
	self assert: announcedSelection asSet equals: #( 'Banana' ) asSet
]
