Class {
	#name : 'AbstractDropdownPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter',
		'announcedItem'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'running' }
AbstractDropdownPresenterTest >> setUp [ 
	super setUp.
	presenter := TestDropdownPresenter new.
	presenter initialize.
	announcedItem := nil.
]

{ #category : 'tests' }
AbstractDropdownPresenterTest >> testAnnounceSelectionWith [

	presenter whenSelectionChangedDo: [ :item | announcedItem := item ].
	presenter announceSelectionWith: 'Banana'.
	self assert: announcedItem equals: 'Banana'
]

{ #category : 'tests' }
AbstractDropdownPresenterTest >> testFilteredItems [

	presenter filteredItems: #( 'A' 'B' ).
	self assert: presenter filteredItems equals: #( 'A' 'B' )
]

{ #category : 'tests' }
AbstractDropdownPresenterTest >> testToggleButtonClickTogglesState [ 
	presenter initializePresenters.
	self deny: (presenter instVarNamed: 'isOpen').
	(presenter instVarNamed: 'toggleButton') mainPresenter action value.
	self assert: (presenter instVarNamed: 'isOpen').
]

{ #category : 'tests' }
AbstractDropdownPresenterTest >> testToggleList [

	self deny: (presenter instVarNamed: 'isOpen').
	presenter toggleList.
	self assert: (presenter instVarNamed: 'isOpen').
	presenter toggleList.
	self deny: (presenter instVarNamed: 'isOpen')
]

{ #category : 'tests' }
AbstractDropdownPresenterTest >> testUpdateToggleButtonIcon [ 
	presenter initializePresenters.
	presenter instVarNamed: 'isOpen' put: false.
	presenter updateToggleButtonIcon.
	self assert: ((presenter instVarNamed: 'toggleButton') mainPresenter icon) equals: (presenter iconNamed: #arrowDown).

	presenter instVarNamed: 'isOpen' put: true.
	presenter updateToggleButtonIcon.
	self assert: ((presenter instVarNamed: 'toggleButton') mainPresenter icon) equals: (presenter iconNamed: #arrowUp).

]
