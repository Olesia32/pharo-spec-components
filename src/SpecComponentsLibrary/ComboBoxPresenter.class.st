Class {
	#name : 'ComboBoxPresenter',
	#superclass : 'BasePresenter',
	#instVars : [
		'textInput',
		'list',
		'toggleButton',
		'allItems',
		'isOpen',
		'isFiltering',
		'selectedItem'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> closeList [

	isFiltering ifTrue: [ ^ self ].
	list mainPresenter visibleIf: false.
	isOpen := false.
	self updateToggleButtonIcon
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> connectPresenters [

	toggleButton action: [ self toggleList ].
	textInput mainPresenter whenTextChangedDo: [ self filterAndShowList ].
	textInput mainPresenter whenSubmitDo: [ :_ | self validateTextInput ].

	list mainPresenter whenSelectedItemChangedDo: [ :item |
			selectedItem := item.
			textInput text: (item ifNotNil: [ item asString ] ifNil: [ '' ]).
			self closeList.
			announcer announce: (ComboBoxItemSelected new item: item) ]
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> defaultLayout [

	| inputRow |
	inputRow := SpBoxLayout newLeftToRight
		            add: textInput mainPresenter;
		            add: toggleButton withConstraints: [ :c |
				            c
					            width: 20;
					            expand: false ];
		            yourself.

	^ SpBoxLayout newTopToBottom
		  add: inputRow expand: false;
		  add: list mainPresenter withConstraints: [ :c |
				  c
					  height: 100;
					  expand: false ];
		  yourself
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> filterAndShowList [

	| query filtered previousText matchedItem |
	isFiltering := true.

	query := textInput text asLowercase.

	filtered := allItems select: [ :each |
		            each notNil and: [
			            each asString asLowercase includesSubstring: query ] ].

	previousText := textInput text.

	list mainPresenter selectItem: nil.
	list mainPresenter items: filtered.

	matchedItem := filtered
		               detect: [ :each | each asString = previousText ]
		               ifNone: [ nil ].

	list mainPresenter selectItem: matchedItem.
	selectedItem := matchedItem.

	isOpen ifTrue: [
			list mainPresenter visibleIf: true.
			self updateToggleButtonIcon ].

	isFiltering := false
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> initializePresenters [

	textInput := TextInputPresenter new.
	textInput width: 100.
	list := ListPresenter new.
	list mainPresenter visibleIf: false.
	toggleButton := SpButtonPresenter new.

	allItems := #(  ).
	selectedItem := nil.
	isOpen := false.
	announcer := Announcer new
]

{ #category : 'accessing' }
ComboBoxPresenter >> items: aCollection [

	allItems := aCollection reject: [ :each | each isNil ].
	 selectedItem := nil.
    textInput text: ''.
	self closeList
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> openList [

	isOpen := true.
	self updateToggleButtonIcon.
	self filterAndShowList.
	list mainPresenter visibleIf: true
]

{ #category : 'accessing' }
ComboBoxPresenter >> selectedItem [

	^ list selectedItem
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> toggleList [ 
    isOpen ifTrue: [ self closeList ] ifFalse: [ self openList ].
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> updateToggleButtonIcon [

	toggleButton icon: (self iconNamed: (isOpen
				  ifTrue: [ #arrowUp ]
				  ifFalse: [ #arrowDown ]))
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> validateTextInput [

	| input match |
	input := textInput text.
	match := allItems
		         detect: [ :each | each asString = input ]
		         ifNone: [ nil ].

	match
		ifNil: [
				selectedItem := nil.
				textInput text: '' ]
		ifNotNil: [
				selectedItem := match.
				textInput text: match asString.
				announcer announce: (ComboBoxItemSelected new item: match) ].

	self closeList
]

{ #category : 'enumerating' }
ComboBoxPresenter >> whenSelectedItemChangedDo: aBlock [ 
    announcer
        when: ComboBoxItemSelected
        do: [ :event | 
            (allItems includes: event item) ifTrue: [
                aBlock value: event item ] ]
        for: self.
]
