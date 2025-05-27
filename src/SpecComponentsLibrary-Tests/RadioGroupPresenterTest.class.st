Class {
	#name : 'RadioGroupPresenterTest',
	#superclass : 'AbstractSelectableGroupPresenterTest',
	#instVars : [
		'selected'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'accessing' }
RadioGroupPresenterTest >> classToTest [ 
^ RadioGroupPresenter 
]

{ #category : 'running' }
RadioGroupPresenterTest >> setUp [ 
	super setUp.
	presenter := RadioGroupPresenter new.
	presenter items: #('A' 'B' 'C').
	presenter initializePresenters.
	selected := nil
]

{ #category : 'tests' }
RadioGroupPresenterTest >> testButtonStateChanged [

	| buttons |
	buttons := presenter instVarNamed: 'buttons'.
	(buttons at: 3) mainPresenter state: true.
	presenter buttonStateChanged.
	self assert: presenter indexSelected equals: 3
]

{ #category : 'tests' }
RadioGroupPresenterTest >> testButtonStateChangedDoesNotCrashOnEmpty [

	presenter instVarNamed: 'buttons' put: OrderedCollection new.
	presenter buttonStateChanged
]

{ #category : 'tests' }
RadioGroupPresenterTest >> testIndexSelected [ 
	self assert: presenter indexSelected equals: 1.
]

{ #category : 'tests' }
RadioGroupPresenterTest >> testIndexSelectedWithNoButtonsReturnsOne [ 
	presenter instVarNamed: 'buttons' put: OrderedCollection new.
	self assert: presenter indexSelected equals: 1.
]

{ #category : 'tests' }
RadioGroupPresenterTest >> testItemSelected [ 
	self assert: presenter itemSelected equals: 'A'.

]

{ #category : 'tests' }
RadioGroupPresenterTest >> testItemSelectedWithInvalidIndexReturnsNil [ 
	presenter instVarNamed: 'index' put: 999.
	self assert: presenter itemSelected isNil.
]

{ #category : 'as yet unclassified' }
RadioGroupPresenterTest >> testUpdateButtons [

	| buttons |
	presenter instVarNamed: 'index' put: 2.
	presenter updateButtons.
	buttons := presenter instVarNamed: 'buttons'.
	self assert: (buttons at: 2) mainPresenter state
]

{ #category : 'tests' }
RadioGroupPresenterTest >> testWhenIndexChangedDo [ 
	| value buttons |
	value := nil.
	presenter whenIndexChangedDo: [ :i | value := i ].
	buttons := presenter instVarNamed: 'buttons'.

	(buttons at: 2) mainPresenter state: true.
	presenter buttonStateChanged.  "перший — пропускає"
	(buttons at: 2) mainPresenter state: true.
	presenter buttonStateChanged.  "другий — викликає блок"

	self assert: value equals: 2.
]
