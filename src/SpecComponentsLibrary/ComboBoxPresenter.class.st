Class {
	#name : 'ComboBoxPresenter',
	#superclass : 'BasePresenter',
	#instVars : [
		'textInput',
		'list',
		'toggleButton',
		'selectedItem',
		'allItems',
		'isOpen'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> closeList [

	list visibleIf: false.
	isOpen := false.
	self updateToggleButtonLabel.
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> connectPresenters [

	textInput whenTextChangedDo: [ self filterAndShowList ].
	list whenSelectedItemChangedDo: [ :item |
			selectedItem := item.
			textInput text: (item ifNotNil: [ item asString ] ifNil: [ '' ]).
			self closeList.
			announcer announce: (ComboBoxItemSelected new item: item). ]
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> defaultLayout [

	| inputRow |
	inputRow := SpBoxLayout newLeftToRight
		            add: textInput;
		            add: toggleButton expand: false;
		            yourself.

	^ SpBoxLayout newTopToBottom
		  add: inputRow expand: false;
		  add: list expand: false;
		  yourself
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> filterAndShowList [ 
    | query filtered |
    query := textInput text asLowercase.
    filtered := allItems
        select: [ :each |
            each notNil and: [
                each asString asLowercase includesSubstring: query ] ].

    list items: filtered.
    list visibleIf: true.
    isOpen := true.
    self updateToggleButtonLabel.

]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> initializePresenters [

	textInput := SpTextInputFieldPresenter new.
	list := SpListPresenter new.
	list visibleIf: false.
	toggleButton := SpButtonPresenter new.

	toggleButton
		icon: (self iconNamed: #dropDownIcon);
		action: [ self toggleList ].

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

	 textInput text: (selectedItem ifNotNil: [ selectedItem asString ] ifNil: [ '' ]).
    self filterAndShowList.
    list visibleIf: true.
    isOpen := true.
    self updateToggleButtonLabel.
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
ComboBoxPresenter >> updateToggleButtonLabel [

	isOpen
		ifTrue: [ toggleButton icon: (self iconNamed: #dropDownIcon) ]
		ifFalse: [ toggleButton icon: (self iconNamed: #dropDownIcon) ]
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
