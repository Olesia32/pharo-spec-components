Class {
	#name : 'MultiSelectComboBoxPresenter',
	#superclass : 'AbstractDropdownPresenter',
	#instVars : [
		'selectedItems',
		'checkboxes',
		'listPresenter'
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

	morphList ifNotNil: [ ^ morphList := listPresenter adapter widget ].
	self updateListWith: filteredItems.
	listPresenter build.
	morphList := listPresenter adapter widget.
	^ morphList
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
	listPresenter := SpComponentListPresenter new.
	textInput mainPresenter placeholder: 'Фільтр...'
]

{ #category : 'api' }
MultiSelectComboBoxPresenter >> items: arg1 [

	super items: arg1.
	selectedItems := Set new.
	self filterList
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> selectedIndexes: anIndexList [ 
    selectedItems := Set new.

    anIndexList do: [ :index |
        (index between: 1 and: allItems size)
            ifTrue: [
                | item |
                item := allItems at: index.
                selectedItems add: item.
            ].
    ].

    self updateListWith: filteredItems.
    announcer announce: (ComboBoxItemSelected new item: selectedItems).
]

{ #category : 'accessing' }
MultiSelectComboBoxPresenter >> selectedItems [

	^ selectedItems
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> updateListWith: arg1 [

	checkboxes := Dictionary new.
	listPresenter ifNil: [ ^ self ].
	listPresenter items: #(  ).
	arg1 do: [ :arg2 |
			| tmp1 tmp3 |
			tmp1 := CheckboxPresenter new.
			tmp3 := tmp1 mainPresenter.
			tmp3
				label: arg2 asString;
				state: (selectedItems includes: arg2);
				whenChangedDo: [ :arg3 |
						arg3
							ifTrue: [ selectedItems add: arg2 ]
							ifFalse: [ selectedItems remove: arg2 ].
						announcer announce:
								(ComboBoxItemSelected new item: selectedItems) ].
			checkboxes at: arg2 put: tmp1.
			listPresenter addPresenter: tmp1 ].
		listPresenter build.
		morphList ifNotNil: [ 
			self closeMorphList.
			morphList := listPresenter adapter widget.
			self openMorphList 
			 ]
]

{ #category : 'enumerating' }
MultiSelectComboBoxPresenter >> whenSelectionChangedDo: aBlock [ 
    announcer
        when: ComboBoxItemSelected
        do: [ :evt | aBlock value: evt item ]
        for: self.
]
