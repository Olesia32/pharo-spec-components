Class {
	#name : 'MultiSelectComboBoxPresenter',
	#superclass : 'AbstractDropdownPresenter',
	#instVars : [
		'selectedItems',
		'checkboxes'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
MultiSelectComboBoxPresenter >> connectPresenters [

	textInput mainPresenter whenTextChangedDo: [ self filterList ].
	toggleButton onClick: [ self toggleList ]
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> createMorphList [

	| tmp1 |
	tmp1 := SpFTTableMorph new
		        on: self
		        list: #filteredItems
		        selected: #selectedIndex
		        changeSelected: #selectIndex:.
	^ tmp1
]

{ #category : 'private' }
MultiSelectComboBoxPresenter >> filterList [

	| tmp1 |
	tmp1 := textInput text asLowercase.
	filteredItems := allItems select: [ :arg1 |
		                 arg1 asString asLowercase includesSubstring: tmp1 ].
	self updateListWith: filteredItems
]

{ #category : 'initialization' }
MultiSelectComboBoxPresenter >> initialize [ 
    super initialize.
    selectedItems := Set new.
    checkboxes := Dictionary new.
]

{ #category : 'initialization' }
MultiSelectComboBoxPresenter >> initializePresenters [

	super initializePresenters.
	textInput mainPresenter placeholder: 'Фільтр...'
]

{ #category : 'api' }
MultiSelectComboBoxPresenter >> items: arg1 [

	super items: arg1.
	selectedItems := Set new.
	self filterList
]

{ #category : 'accessing' }
MultiSelectComboBoxPresenter >> selectedItems [

	^ selectedItems
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> updateListWith: arg1 [

	checkboxes := Dictionary new.
	morphList ifNil: [ ^ self ] ifNotNil: [ morphList items: #(  ) ].
	arg1 do: [ :arg2 |
			| tmp1 |
			tmp1 := CheckboxPresenter new.
			tmp1 mainPresenter
				label: arg2 asString;
				state: (selectedItems includes: arg2);
				whenChangedDo: [ :arg3 |
						arg3
							ifTrue: [ selectedItems add: arg2 ]
							ifFalse: [ selectedItems remove: arg2 ].
						announcer announce:
								(ComboBoxItemSelected new item: selectedItems) ].
			checkboxes at: arg2 put: tmp1.
			morphList addPresenter: tmp1 ]
]

{ #category : 'enumerating' }
MultiSelectComboBoxPresenter >> whenSelectionChangedDo: aBlock [ 
    announcer
        when: ComboBoxItemSelected
        do: [ :evt | aBlock value: evt item ]
        for: self.
]
