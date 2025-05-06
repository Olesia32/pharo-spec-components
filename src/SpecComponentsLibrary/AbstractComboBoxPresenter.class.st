Class {
	#name : 'AbstractComboBoxPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textInput',
		'toggleButton',
		'list',
		'allItems',
		'isOpen',
		'morphList',
		'selectedIndex'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'testing' }
AbstractComboBoxPresenter class >> isAbstract [ 
^ true
]

{ #category : 'accessing' }
AbstractComboBoxPresenter >> allItems [

	^ allItems
]

{ #category : 'as yet unclassified' }
AbstractComboBoxPresenter >> announceSelectionWith: item [ 
	announcer announce: (ComboBoxItemSelected new item: item)
]

{ #category : 'as yet unclassified' }
AbstractComboBoxPresenter >> closeMorphList [

	morphList ifNotNil: [
			morphList delete.
			morphList := nil ]
]

{ #category : 'initialization' }
AbstractComboBoxPresenter >> connectPresenters [ 
 self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
AbstractComboBoxPresenter >> createListPresenter [ 
    ^ SpPresenter new "Підклас може перевизначити на ListPresenter чи SpComponentListPresenter"
]

{ #category : 'layout' }
AbstractComboBoxPresenter >> defaultLayout [

	| tmp1 tmp2 |
	tmp2 := SpBoxLayout newLeftToRight.
	tmp2 add: textInput mainPresenter.
	tmp1 := SpBoxLayout newTopToBottom add:
		        (tmp2 add: toggleButton withConstraints: [ :arg1 |
				         arg1
					         width: 25;
					         expand: false ]).
	^ tmp1
]

{ #category : 'private' }
AbstractComboBoxPresenter >> filterList [ 
 self subclassResponsibility 
]

{ #category : 'initialization' }
AbstractComboBoxPresenter >> initialize [ 
	super initialize.
	allItems := #().
	announcer := Announcer new.
]

{ #category : 'initialization' }
AbstractComboBoxPresenter >> initializePresenters [

	textInput := TextInputPresenter new.
	isOpen := false.
	toggleButton := ButtonPresenter new.
	toggleButton
		onClick: [ self toggleList ];
		backgroundColor: '#ffffff'.
	list := self createListPresenter.
	self
		updateToggleButtonIcon;
		connectPresenters
]

{ #category : 'api' }
AbstractComboBoxPresenter >> items: aCollection [ 
	allItems := aCollection reject: [ :each | each isNil ].
	self filterList
]

{ #category : 'as yet unclassified' }
AbstractComboBoxPresenter >> openMorphList [

	| tmp1 width |
	morphList := PluggableListMorph
		             on: self
		             list: #allItems
		             selected: #selectedIndex
		             changeSelected: #selectIndex:.
	
	width := textInput mainPresenter adapter widget width.
	morphList width: width.
	morphList
		color: Color white.
	tmp1 := textInput mainPresenter adapter widget bounds bottomLeft.
	morphList position: tmp1.
	World addMorph: morphList.
	morphList comeToFront
]

{ #category : 'api - selection' }
AbstractComboBoxPresenter >> selectIndex: anIndex [ 
	selectedIndex := anIndex.
	anIndex > 0 ifTrue: [
		| item |
		item := allItems at: anIndex.
		textInput text: item asString.
		self announceSelectionWith: item
	].
	self closeMorphList.
	isOpen := false.
	self updateToggleButtonIcon.
]

{ #category : 'accessing' }
AbstractComboBoxPresenter >> selectedIndex [ 
	^ selectedIndex
]

{ #category : 'as yet unclassified' }
AbstractComboBoxPresenter >> toggleList [

	isOpen
		ifTrue: [ self closeMorphList ]
		ifFalse: [ self openMorphList ].
	isOpen := isOpen not.
	self updateToggleButtonIcon
]

{ #category : 'as yet unclassified' }
AbstractComboBoxPresenter >> updateToggleButtonIcon [ 
	toggleButton mainPresenter icon: (self iconNamed: (isOpen ifTrue: [#arrowUp] ifFalse: [#arrowDown]))
]

{ #category : 'enumerating' }
AbstractComboBoxPresenter >> whenSelectionChangedDo: aBlock [ 
    announcer
        when: ComboBoxItemSelected
        do: [ :event | aBlock value: event item ]
        for: self.
]
