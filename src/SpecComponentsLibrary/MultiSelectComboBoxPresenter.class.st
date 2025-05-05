Class {
	#name : 'MultiSelectComboBoxPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textInput',
		'toggleButton',
		'list',
		'allItems',
		'selectedItems',
		'checkboxes',
		'isOpen'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> defaultLayout [ 
    ^ SpBoxLayout newTopToBottom
        add: (SpBoxLayout newLeftToRight
            add: textInput mainPresenter;
            add: toggleButton withConstraints: [ :c |
                c width: 25; expand: false ]);
        add: list withConstraints: [ :c |
            c height: 150; expand: false ];
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
    allItems := #().
    selectedItems := Set new.
    checkboxes := Dictionary new.
    isOpen := false.
    announcer := Announcer new.
]

{ #category : 'initialization' }
MultiSelectComboBoxPresenter >> initializePresenters [ 
    textInput := TextInputPresenter new.
    textInput mainPresenter placeholder: 'Фільтр...'.
    textInput mainPresenter whenTextChangedDo: [ self filterList ].

    toggleButton := SpButtonPresenter new.
    toggleButton label: '▼'.
    toggleButton action: [ self toggleList ].

    list := SpComponentListPresenter new.
    list visibleIf: false.
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
        list addPresenter: cb.
    ].
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> updateToggleButtonIcon [ 
    toggleButton icon: (self iconNamed: (isOpen ifTrue: [#arrowUp] ifFalse: [#arrowDown]))
]

{ #category : 'enumerating' }
MultiSelectComboBoxPresenter >> whenSelectionChangedDo: aBlock [ 
    announcer
        when: ComboBoxItemSelected
        do: [ :evt | aBlock value: evt item ]
        for: self.
]
