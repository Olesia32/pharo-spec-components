Class {
	#name : 'AbstractSelectableGroupPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'running' }
AbstractSelectableGroupPresenterTest >> setUp [ 
	super setUp.
	presenter := TestSelectableGroupPresenter new.
	presenter initialize.
	presenter initializePresenters.
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testAddItem [

	| buttonsBefore buttonsAfter |
	presenter items: #( 'X' ).
	buttonsBefore := presenter instVarNamed: 'buttons' copy.
	presenter addItem: 'Y'.
	buttonsAfter := presenter instVarNamed: 'buttons'.
	self assert: buttonsAfter size equals: 2.
	self deny: buttonsBefore equals: buttonsAfter
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testDisplay [

	| firstLabel |
	presenter items: #( 1 2 3 ).
	presenter display: [ :each | 'Item ' , each asString ].
	presenter updateLabels.
	firstLabel := (presenter instVarNamed: 'buttons') first.
	self assert: firstLabel text equals: 'Item 1'.
	
   presenter disableButtonAt: -1
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testEnableButtonAtInvalidIndexDoesNotFail [

	presenter enableButtonAt: 999
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testEnableDisableButtonAtIndex [

	presenter items: #( 'A' ).
	presenter enableButtonAt: 1.
	presenter disableButtonAt: 1.
	self deny:
		(presenter instVarNamed: 'buttons') first mainPresenter isEnabled
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testEnableScrolling [

	| layout |
	presenter enableScrolling: true.
	layout := presenter generateLayout.
	self assert: (layout isKindOf: SpScrollableLayout)
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testItemAtIndex [

	self assert: (presenter itemAtIndex: 100) isNil
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testItems [

	presenter items: #( 'A' 'B' ).
	self
		assert: (presenter instVarNamed: 'items')
		equals: #( 'A' 'B' ) asOrderedCollection.
	self assert: (presenter instVarNamed: 'buttons') size equals: 2
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testItemsWithSameSizeOnlyUpdatesLabels [

	| labels |
	presenter items: #( 'A' 'B' ).
	presenter display: [ :each | '1' ].
	presenter items: #( 'X' 'Y' ).
	labels := (presenter instVarNamed: 'buttons') collect: [ :b |
		          b mainPresenter label ].
	self assert: labels asArray equals: #('1' '1').

]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testMultipleColumnsBuildsNestedLayouts [

	| layout |
	presenter items: #( 'A' 'B' 'C' 'D' ).
	presenter сolumnCount: 2.
	layout := presenter buildColumnLayout: 2.
	self assert: (layout isKindOf: SpBoxLayout).
	self assert: layout direction class equals: SpHorizontalLayoutDirection .
	self assert: layout children size equals: 2 "2 columns"
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testRemoveItem [

	presenter items: #( 'One' 'Two' ).
	presenter removeItem: 'Two'.
	self assert: (presenter instVarNamed: 'items') size equals: 1.
	self assert: (presenter instVarNamed: 'buttons') size equals: 1
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testShowFrame [

   | layout |
	presenter showFrame: true.
	self assert: (presenter instVarNamed: 'showFrame').
	layout := presenter generateLayout.
	self assert: (layout isKindOf: SpFrameLayout)
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testShowTitle [

	presenter showTitle: true.
	self assert: (presenter instVarNamed: 'showTitle')
]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testSingleColumnBuildsVerticalLayout [

	| layout |
	presenter items: #( 'A' 'B' 'C' ).
	presenter сolumnCount: 1.
	layout := presenter generateLayout.
	self assert: (layout isKindOf: SpBoxLayout).
	self assert: layout direction class equals: SpVerticalLayoutDirection.

]

{ #category : 'tests' }
AbstractSelectableGroupPresenterTest >> testСolumnCount [

	presenter сolumnCount: 0.
	self assert: (presenter instVarNamed: 'columnCount') equals: 1
]
