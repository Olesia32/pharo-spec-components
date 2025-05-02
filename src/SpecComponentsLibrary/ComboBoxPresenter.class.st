Class {
	#name : 'ComboBoxPresenter',
	#superclass : 'BasePresenter',
	#instVars : [
		'inputPresenter',
		'listPresenter',
		'items',
		'filteredItems',
		'selectedItem'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'api' }
ComboBoxPresenter >> applyFilter: filterText [

	filteredItems := items select: [ :each |
		                 each asString
			                 includesSubstring: filterText
			                 caseSensitive: false ].
	listPresenter mainPresenter items: filteredItems
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> connectPresenters [

	inputPresenter mainPresenter whenTextChangedDo: [ :text |
		self applyFilter: text ].
	listPresenter mainPresenter whenSelectionChangedDo: [ :selection |
		selectedItem := selection selectedItem ]
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 0;
		  add: inputPresenter;
		  add: listPresenter;
		  yourself
]

{ #category : 'as yet unclassified' }
ComboBoxPresenter >> initializePresenters [

	super initializePresenters.
	inputPresenter := TextInputPresenter new.
	listPresenter := ListPresenter new.
	self focusOrder
		add: inputPresenter;
		add: listPresenter
]

{ #category : 'accessing' }
ComboBoxPresenter >> items: aCollection [ 
    items := aCollection.
    self applyFilter: (inputPresenter text ifNil: ['']).


]

{ #category : 'accessing' }
ComboBoxPresenter >> selectedItem [ 
    ^ selectedItem
]
