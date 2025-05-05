Class {
	#name : 'MultiSelectComboBoxPresenter',
	#superclass : 'AbstractComboBoxPresenter',
	#instVars : [
		'selectedItems',
		'checkboxes'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
MultiSelectComboBoxPresenter >> connectPresenters [ 
    toggleButton onClick: [ self toggleList ].
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> createListPresenter [
   ^ SpComponentListPresenter new
]

{ #category : 'layout' }
MultiSelectComboBoxPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: textInput mainPresenter;
			add: toggleButton withConstraints: [ :c | c width: 25; expand: false ]) expand: false;
		   add: list withConstraints: [ :c | c  expand: false; height: 150];
		yourself
]

{ #category : 'private' }
MultiSelectComboBoxPresenter >> filterList [ 
    | query filtered |
    query := textInput text asLowercase.
    filtered := allItems select: [ :each |
        each asString asLowercase includesSubstring: query ].
    self updateListWith: filtered.
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
    list visibleIf: false.
    textInput mainPresenter placeholder: 'Фільтр...'.
    textInput mainPresenter whenTextChangedDo: [ self filterList ].
]

{ #category : 'api' }
MultiSelectComboBoxPresenter >> items: aCollection [ 
    allItems := aCollection reject: [ :each | each isNil ].
    selectedItems := Set new.
    self filterList
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> toggleList [ 
    isOpen := isOpen not.
    list visibleIf: isOpen.
    self updateToggleButtonIcon.
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> updateListWith: visibleItems [ 
    list items: #().
    checkboxes := Dictionary new.

    visibleItems do: [ :item |
        | cb |
        cb := CheckboxPresenter new.
        cb mainPresenter label: item asString.
        cb mainPresenter state: (selectedItems includes: item).
        cb mainPresenter whenChangedDo: [ :checked |
            checked
                ifTrue: [ selectedItems add: item ]
                ifFalse: [ selectedItems remove: item ].
            announcer announce: (ComboBoxItemSelected new item: selectedItems) ].
        checkboxes at: item put: cb .
        list addPresenter: cb.]
]

{ #category : 'enumerating' }
MultiSelectComboBoxPresenter >> whenSelectionChangedDo: aBlock [ 
    announcer
        when: ComboBoxItemSelected
        do: [ :evt | aBlock value: evt item ]
        for: self.
]
