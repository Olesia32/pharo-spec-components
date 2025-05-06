Class {
	#name : 'ComboBoxPresenter',
	#superclass : 'AbstractComboBoxPresenter',
	#instVars : [
		'isFiltering',
		'selectedItem'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
ComboBoxPresenter >> connectPresenters [

	textInput mainPresenter whenTextChangedDo: [ self filterList ].
	list mainPresenter whenSelectedItemChangedDo: [ :arg1 |
			selectedItem := arg1.
			textInput text: (arg1 ifNil: [ '' ] ifNotNil: [ arg1 asString ]).
			announcer announce: (ComboBoxItemSelected new item: arg1) ]
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> createListPresenter [
   ^ ListPresenter new
]

{ #category : 'initialization' }
ComboBoxPresenter >> filterList [ 
    | query filtered previousText matchedItem |
    isFiltering := true.

    query := textInput text asLowercase.

    filtered := allItems select: [ :each |
        each notNil and: [ each asString asLowercase includesSubstring: query ] ].

    previousText := textInput text.
    list mainPresenter resetListSelection.
    list mainPresenter items: filtered.

    list mainPresenter resetListSelection.

    matchedItem := filtered
        detect: [ :each | each asString = previousText ]
        ifNone: [ nil ].

    matchedItem ifNotNil: [
        list mainPresenter selectItem: matchedItem.
        selectedItem := matchedItem
    ] ifNil: [
        list mainPresenter selectItem: nil.
        selectedItem := nil
    ].

    isFiltering := false.
]

{ #category : 'accessing' }
ComboBoxPresenter >> items: aCollection [ 
    allItems := aCollection reject: [ :each | each isNil ].
    selectedItem := nil.
    textInput text: ''.
    list mainPresenter items: allItems.  
    list mainPresenter selectItem: nil. 

]

{ #category : 'accessing' }
ComboBoxPresenter >> selectedItem [ 
    ^ list selectedItem
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> validateTextInput [ 
    | input match |
    input := textInput text.
    match := allItems detect: [ :each | each asString = input ] ifNone: [ nil ].

    match
        ifNil: [
            selectedItem := nil.
            textInput text: '' ]
        ifNotNil: [
            selectedItem := match.
            textInput text: match asString.
            announcer announce: (ComboBoxItemSelected new item: match) ].

    list mainPresenter selectItem: nil.
    self toggleList
]
