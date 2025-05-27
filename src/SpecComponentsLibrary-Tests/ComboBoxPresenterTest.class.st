Class {
	#name : 'ComboBoxPresenterTest',
	#superclass : 'AbstractDropdownPresenterTest',
	#instVars : [
		'selection'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
ComboBoxPresenterTest >> classToTest [ 
  ^ ComboBoxPresenter 
]

{ #category : 'running' }
ComboBoxPresenterTest >> setUp [ 
	super setUp.
	presenter := ComboBoxPresenter new.
	presenter initialize.
	presenter items: #('Apple' 'Banana' 'Orange').
	selection := nil.
]

{ #category : 'tests' }
ComboBoxPresenterTest >> testFilterList [

	presenter textInput text: 'an'.
	presenter filterList.
	self assert: presenter filteredItems equals: #( 'Banana' 'Orange' )
]

{ #category : 'tests' }
ComboBoxPresenterTest >> testItems [

	self
		assert: presenter allItems
		equals: #( 'Apple' 'Banana' 'Orange' ).
	self
		assert: presenter filteredItems
		equals: #( 'Apple' 'Banana' 'Orange' )
]

{ #category : 'tests' }
ComboBoxPresenterTest >> testItemsRejectsNilAndSetsFilteredItems [ 
	presenter items: #('A' nil 'B').
	self assert: presenter allItems equals: #('A' 'B').
	self assert: presenter filteredItems equals: #('A' 'B').
]

{ #category : 'tests' }
ComboBoxPresenterTest >> testSelectIndex [

	presenter selectIndex: 2.
	self assert: presenter selectedIndex equals: 2.
	self assert: presenter selectedItem equals: 'Banana'.
	self assert: presenter textInput text equals: 'Banana'
]

{ #category : 'tests' }
ComboBoxPresenterTest >> testSelectIndexWithInvalidIndexDoesNotCrash [ 
	presenter whenSelectionChangedDo: [ :val | selection := val ].
	presenter selectIndex: 10.
	self assert: presenter selectedIndex equals: 10.
	self assert: selection isNil.
]

{ #category : 'tests' }
ComboBoxPresenterTest >> testSelectedItem [
	presenter selectedIndex: 2.
	self
		assert: presenter selectedItem
		equals: 'Banana'
]

{ #category : 'tests' }
ComboBoxPresenterTest >> testWhenSelectionChangedDo [ 
	presenter whenSelectionChangedDo: [ :value | selection := value ].
	presenter selectIndex: 3.
	self assert: selection equals: 'Orange'.
]
