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

    list mainPresenter whenSelectedItemChangedDo: [ :item |
        selectedItem := item.
        textInput text: (item ifNotNil: [ item asString ] ifNil: [ '' ]).
        self toggleList.
        announcer announce: (ComboBoxItemSelected new item: item) ]
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
    list mainPresenter selectItem: nil.
    list mainPresenter items: filtered.

    matchedItem := filtered detect: [ :each | each asString = previousText ] ifNone: [ nil ].
    list mainPresenter selectItem: matchedItem.
    selectedItem := matchedItem.
    isFiltering := false.
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> initializePresenters [

	super initializePresenters.
   list mainPresenter visibleIf: false.
]

{ #category : 'accessing' }
ComboBoxPresenter >> items: aCollection [

	allItems := aCollection reject: [ :each | each isNil ].
	 selectedItem := nil.
    textInput text: ''.

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
