Class {
	#name : 'MultiSelectComboBoxPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textInput',
		'checkboxContainer',
		'toggleButton',
		'allItems',
		'filteredItems',
		'selectedItems',
		'isOpen',
		'checkboxes'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: textInput;
				   add: toggleButton withConstraints: [ :c |
						   c
							   width: 20;
							   expand: false ]);
		  add: checkboxContainer mainPresenter withConstraints: [ :c |
			  c
				  height: 150;
				  expand: false ];
		  yourself
]

{ #category : 'private' }
MultiSelectComboBoxPresenter >> filterList [ 
    | query |
    query := textInput text asLowercase.
    filteredItems := allItems select: [ :each |
        each asString asLowercase includesSubstring: query ].
    self updateCheckboxes
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> initializePresenters [

	textInput := TextInputPresenter new.
	textInput placeholder: 'Пошук...'; height: 50.
	textInput mainPresenter whenTextChangedDo: [ self filterList ].

	toggleButton := SpButtonPresenter new.
	toggleButton icon: (self iconNamed: #arrowDown).
	toggleButton action: [ self toggleList ].

	checkboxContainer := BasePresenter new.
	checkboxContainer mainPresenter: SpPresenter new.
	checkboxContainer mainPresenter layout: SpBoxLayout newTopToBottom.
	checkboxContainer mainPresenter visibleIf: false.

	allItems := #(  ).
	filteredItems := #(  ).
	selectedItems := Set new.
	checkboxes := Dictionary new.
	isOpen := false.
	announcer := Announcer new
]

{ #category : 'api' }
MultiSelectComboBoxPresenter >> items: aCollection [ 
    allItems := aCollection.
    self filterList
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> toggleList [ 
    isOpen := isOpen not.
    checkboxContainer visibleIf: isOpen.
    self updateToggleButtonIcon
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> updateCheckboxes [

	| layout |
	layout := checkboxContainer mainPresenter layout.
	layout removeAll.

	checkboxes := Dictionary new.

	filteredItems do: [ :item |
			| cb |
			cb := self newCheckBox.
			cb label: item asString.
			cb state: (selectedItems includes: item).
			cb whenChangedDo: [ :checked |
					checked
						ifTrue: [ selectedItems add: item ]
						ifFalse: [ selectedItems remove: item ].
					announcer announce:
						(ComboBoxItemSelected new item: selectedItems) ].
			checkboxes at: item put: cb.
			layout add: cb]
]

{ #category : 'as yet unclassified' }
MultiSelectComboBoxPresenter >> updateToggleButtonIcon [ 
    toggleButton icon: (self iconNamed: (isOpen ifTrue: [#arrowUp] ifFalse: [#arrowDown]))
]

{ #category : 'enumerating' }
MultiSelectComboBoxPresenter >> whenSelectionChangedDo: aBlock [ 
    announcer
        when: ComboBoxItemSelected
        do: [ :event | aBlock value: event item ]
        for: self
]
