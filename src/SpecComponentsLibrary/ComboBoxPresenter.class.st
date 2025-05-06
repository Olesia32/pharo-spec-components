Class {
	#name : 'ComboBoxPresenter',
	#superclass : 'AbstractDropdownPresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
ComboBoxPresenter >> connectPresenters [

	textInput mainPresenter whenTextChangedDo: [ self filterList ]
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> createMorphList [

	^ PluggableListMorph
		  on: self
		  list: #filteredItems
		  selected: #selectedIndex
		  changeSelected: #selectIndex:
]

{ #category : 'private' }
ComboBoxPresenter >> filterList [

	| tmp1 tmp2 |
	tmp1 := textInput text asLowercase.
	filteredItems := allItems select: [ :arg1 |
		                 arg1 asString asLowercase includesSubstring: tmp1 ].
	tmp2 := filteredItems
		        detect: [ :arg2 | arg2 asString = textInput text ]
		        ifNone: [ ].
	selectedIndex := tmp2
		        ifNil: [ 0 ]
		        ifNotNil: [ allItems indexOf: tmp2 ifAbsent: 0 ].
	isOpen ifFalse: [ ^ self ].
	self
		closeMorphList;
		openMorphList
]

{ #category : 'initialization' }
ComboBoxPresenter >> initialize [

	super initialize.
	selectedIndex := 0.
]

{ #category : 'initialization' }
ComboBoxPresenter >> initializePresenters [

	super initializePresenters
]

{ #category : 'accessing' }
ComboBoxPresenter >> items: arg1 [

	super items: arg1.
	filteredItems := allItems.
	self filterList
]

{ #category : 'api - selection' }
ComboBoxPresenter >> selectIndex: anIndex [

	selectedIndex := anIndex.

	anIndex > 0 ifTrue: [
			| item |
			item := filteredItems at: anIndex.
			textInput text: item asString.
			announcer announce: (ComboBoxItemSelected new item: item) ].

	self closeMorphList.
	isOpen := false.
	self updateToggleButtonIcon
]

{ #category : 'accessing' }
ComboBoxPresenter >> selectedItem [ 
    ^ list selectedItem
]
