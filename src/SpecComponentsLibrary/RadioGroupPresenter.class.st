Class {
	#name : 'RadioGroupPresenter',
	#superclass : 'AbstractSelectableGroupPresenter',
	#instVars : [
		'index',
		'whenIndexChangedDo',
		'isEvenEvent'
	],
	#category : 'SpecComponentsLibrary-Groups',
	#package : 'SpecComponentsLibrary',
	#tag : 'Groups'
}

{ #category : 'building' }
RadioGroupPresenter >> buildButton [
"Creates and returns a new RadioButtonPresenter for an item in the group."
	^ RadioButtonPresenter new
]

{ #category : 'events' }
RadioGroupPresenter >> buttonStateChanged [
"Triggered when any radio button changes state.
Updates the selected index and calls the event callback (if defined), but only on every second change due to isEvenEvent toggling."
	buttons withIndexDo: [ :btn :ind |
		btn mainPresenter state ifTrue: [ index := ind ] ].

	isEvenEvent ifTrue: [
		whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ] ].

	isEvenEvent := isEvenEvent not
]

{ #category : 'initialization' }
RadioGroupPresenter >> connectPresenters [
"Connects all radio buttons to a shared change handler that detects which button is selected and updates internal state."
	| block |
	block := [ self buttonStateChanged ].
	buttons do: [ :btn | btn mainPresenter whenChangedDo: block ]
]

{ #category : 'private' }
RadioGroupPresenter >> correctIndexToFirst [
"Resets the selection to the first item and triggers the index change event if it is set."
	index := 1.
	whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ]
]

{ #category : 'accessing' }
RadioGroupPresenter >> indexSelected [
"Returns the index (1-based) of the currently selected radio button."
	^ index
]

{ #category : 'initialization' }
RadioGroupPresenter >> initialize [ 
    super initialize.
    index := 1.
    isEvenEvent := false.
]

{ #category : 'accessing' }
RadioGroupPresenter >> itemSelected [
"Returns the currently selected item from the items collection based on the stored index."
	^ items at: index ifAbsent: [ nil ]
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> itemSelected: anIndex [
   index := anIndex 
]

{ #category : 'updating' }
RadioGroupPresenter >> updateButtons [
"Creates one radio button per item, ensuring that only one can be selected at a time.
Groups all buttons into a shared radio button group.
Restores selection if a valid index was previously stored."
	| firstButton presenters |
	firstButton := self buildButton.
	buttons := OrderedCollection with: firstButton.
	items allButFirstDo: [ :ignored | buttons add: self buildButton ].

	presenters := buttons allButFirst collect: [ :b | b mainPresenter ].
	firstButton mainPresenter associatedRadioButtons: presenters.

	self updateLabels.
	(index notNil and: [ index between: 1 and: buttons size ]) ifTrue: [
		(buttons at: index) mainPresenter state: true ]
]

{ #category : 'accessing' }
RadioGroupPresenter >> whenIndexChangedDo: aBlock [
"Sets the callback block to be triggered whenever the selected index changes."
	whenIndexChangedDo := aBlock
]
