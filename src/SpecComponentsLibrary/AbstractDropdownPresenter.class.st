"
Абстрактний базовий клас для випадаючих компонентів (ComboBox, MultiSelectComboBox).

Містить логіку відкриття/закриття списку, фільтрації, взаємодії з кнопкою та полем введення.
Підкласи повинні реалізувати методи #createMorphList та #filterList.

"
Class {
	#name : 'AbstractDropdownPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textInput',
		'toggleButton',
		'list',
		'allItems',
		'isOpen',
		'morphList',
		'filteredItems',
		'selectedIndex'
	],
	#category : 'SpecComponentsLibrary-Dropdown',
	#package : 'SpecComponentsLibrary',
	#tag : 'Dropdown'
}

{ #category : 'testing' }
AbstractDropdownPresenter class >> isAbstract [ 
^ true
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> allItems [

	^ allItems
]

{ #category : 'private' }
AbstractDropdownPresenter >> announceSelectionWith: arg1 [

	announcer announce: (ComboBoxItemSelected new item: arg1)
]

{ #category : 'private' }
AbstractDropdownPresenter >> closeMorphList [

	morphList ifNotNil: [
			morphList delete.
			morphList := nil ]
]

{ #category : 'initialization' }
AbstractDropdownPresenter >> connectPresenters [ 
 self subclassResponsibility 
]

{ #category : 'private' }
AbstractDropdownPresenter >> createListPresenter [ 
    ^ SpPresenter new "Підклас може перевизначити на ListPresenter чи SpComponentListPresenter"
]

{ #category : 'private' }
AbstractDropdownPresenter >> createMorphList [

	self subclassResponsibility
]

{ #category : 'layout' }
AbstractDropdownPresenter >> defaultLayout [

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
AbstractDropdownPresenter >> filterList [ 
 self subclassResponsibility 
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> filteredItems [

	^ filteredItems
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> filteredItems: arg1 [

	filteredItems := arg1
]

{ #category : 'initialization' }
AbstractDropdownPresenter >> initialize [

	super initialize.
	allItems := #(  ).
	filteredItems := #(  ).
	announcer := Announcer new.
	isOpen := false
]

{ #category : 'initialization' }
AbstractDropdownPresenter >> initializePresenters [

	textInput := TextInputPresenter new.
	toggleButton := ButtonPresenter new.
	toggleButton onClick: [ self toggleList ].
	isOpen := false.
	self updateToggleButtonIcon
]

{ #category : 'api' }
AbstractDropdownPresenter >> items: arg1 [

	allItems := arg1 reject: [ :arg2 | arg2 isNil ]
]

{ #category : 'private' }
AbstractDropdownPresenter >> openMorphList [

	| tmp1 tmp2 |
	morphList := self createMorphList.
	morphList color: Color white.
	tmp1 := textInput mainPresenter adapter widget bounds bottomLeft.
	tmp2 := textInput mainPresenter adapter widget width.
	morphList
		width: tmp2;
		position: tmp1;
		height: 100.
	World addMorph: morphList.
	morphList comeToFront
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> selectedIndex [

	^ selectedIndex
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> selectedIndex: anObject [

	selectedIndex := anObject
]

{ #category : 'private' }
AbstractDropdownPresenter >> toggleList [

	isOpen
		ifTrue: [ self closeMorphList ]
		ifFalse: [ self openMorphList ].
	isOpen := isOpen not.
	self updateToggleButtonIcon
]

{ #category : 'private' }
AbstractDropdownPresenter >> updateToggleButtonIcon [ 
	toggleButton mainPresenter icon: (self iconNamed: (isOpen ifTrue: [#arrowUp] ifFalse: [#arrowDown]))
]

{ #category : 'enumerating' }
AbstractDropdownPresenter >> whenSelectionChangedDo: aBlock [ 
    announcer
        when: ComboBoxItemSelected
        do: [ :event | aBlock value: event item ]
        for: self.
]
