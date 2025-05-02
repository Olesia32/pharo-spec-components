Class {
	#name : 'ComboBoxPresenter',
	#superclass : 'BasePresenter',
	#instVars : [
		'textInput',
		'list',
		'listWrapper',
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
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> connectPresenters [
    textInput whenTextChangedDo: [ self filterAndShowList ].
    list whenSelectedItemChangedDo: [ :item |
        textInput text: item asString.
        self closeList]
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: textInput expand: false;
		  add: list expand: false;
		  yourself
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> filterAndShowList [
    | query filtered |
    query := textInput text asLowercase.
    filtered := allItems select: [ :each | 
        each asString asLowercase includesSubstring: query ].

    list items: filtered.
    self openList.
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> initializePresenters [

    textInput := SpTextInputFieldPresenter new.
    list := SpListPresenter new.
    list visibleIf: false.

    allItems := #().
    isOpen := false.
]

{ #category : 'accessing' }
ComboBoxPresenter >> items: aCollection [
    allItems := aCollection.
    self closeList.
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> openList [

	list visibleIf: true.
	isOpen := true
]

{ #category : 'accessing' }
ComboBoxPresenter >> selectedItem [
    ^ list selectedItem.
]
