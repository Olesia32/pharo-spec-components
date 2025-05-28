Class {
	#name : 'CheckboxGroupPresenterTest',
	#superclass : 'AbstractSelectableGroupPresenterTest',
	#instVars : [
		'selected'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
CheckboxGroupPresenterTest >> classToTest [ 
  ^ CheckboxGroupPresenter 
]

{ #category : 'running' }
CheckboxGroupPresenterTest >> setUp [ 
	super setUp.
	presenter := CheckboxGroupPresenter new.
	presenter items: #('A' 'B' 'C').
	presenter initializePresenters.
	selected := nil
]

{ #category : 'tests' }
CheckboxGroupPresenterTest >> testBuildButton [

	self assert: (presenter instVarNamed: 'buttons') size equals: 3.
	self assert: ((presenter instVarNamed: 'buttons') allSatisfy: [ :b |
			 b isKindOf: CheckboxPresenter ])
]

{ #category : 'tests' }
CheckboxGroupPresenterTest >> testClearSelection [

	| buttons |
	buttons := presenter instVarNamed: 'buttons'.
	buttons size >= 2 ifFalse: [ ^ self ].
	buttons first mainPresenter state: true.
	(buttons at: 2) mainPresenter state: true.
	presenter toggleSelectionAt: 1.
	presenter toggleSelectionAt: 2.
	presenter clearSelection.
	self assert: presenter selectedIndexes isEmpty.
	self assert: (buttons allSatisfy: [ :b | b mainPresenter state not ])
]

{ #category : 'tests' }
CheckboxGroupPresenterTest >> testIsCheckedAt [

	| buttons index b |
	buttons := presenter instVarNamed: 'buttons'.
	index := 2.
	index <= buttons size ifTrue: [
			b := buttons at: index.
			b mainPresenter state: true.
			presenter toggleSelectionAt: index ].
	self assert: (presenter isCheckedAt: 2).
	self deny: (presenter isCheckedAt: 1).
	
   self deny: (presenter isCheckedAt: 99).
	self deny: (presenter isCheckedAt: -1)
]

{ #category : 'tests' }
CheckboxGroupPresenterTest >> testSelectedIndexes [

	| buttons |
	buttons := presenter instVarNamed: 'buttons'.
	buttons size >= 3 ifFalse: [ ^ self ].
	(buttons at: 3) mainPresenter state: true.
	buttons first mainPresenter state: true.
	presenter toggleSelectionAt: 3.
	presenter toggleSelectionAt: 1.
	self assert: presenter selectedIndexes asArray equals: #( 1 3 )
]

{ #category : 'accessing' }
CheckboxGroupPresenterTest >> testSelectedItems [

	| buttons |
	buttons := presenter instVarNamed: 'buttons'.
	buttons size >= 2 ifFalse: [ ^ self ].
	buttons first mainPresenter state: true.
	(buttons at: 2) mainPresenter state: true.
	presenter toggleSelectionAt: 1.
	presenter toggleSelectionAt: 2.
	self assert: presenter selectedItems asArray equals: #( 'A' 'B' )
]

{ #category : 'tests' }
CheckboxGroupPresenterTest >> testToggleSelectionAt [

	| buttons |
	buttons := presenter instVarNamed: 'buttons'.
	buttons size >= 2 ifFalse: [ ^ self ].
	(buttons at: 2) mainPresenter state: true.
	presenter toggleSelectionAt: 2.
	(buttons at: 2) mainPresenter state: false.
	presenter toggleSelectionAt: 2.
	self assert: presenter selectedIndexes isEmpty.
	
   presenter toggleSelectionAt: 99.
	presenter toggleSelectionAt: 0
]

{ #category : 'tests' }
CheckboxGroupPresenterTest >> testWhenSelectionChangedDo [

	| buttons |
	presenter whenSelectionChangedDo: [ :indexes | selected := indexes ].
	buttons := presenter instVarNamed: 'buttons'.
	buttons size >= 2 ifFalse: [ ^ self ].
	(buttons at: 2) mainPresenter state: true.
	presenter toggleSelectionAt: 2.
	self assert: selected asArray equals: #( 2 )
]
