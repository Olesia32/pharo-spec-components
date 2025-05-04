Class {
	#name : 'RadioGroupPresenter',
	#superclass : 'AbstractSelectableGroupPresenter',
	#instVars : [
		'index',
		'whenIndexChangedDo',
		'isEvenEvent'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'building' }
RadioGroupPresenter >> buildButton [ 
    ^ RadioButtonPresenter new
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> buttonStateChanged [ 
    buttons withIndexDo: [ :btn :ind |
        btn mainPresenter state ifTrue: [ index := ind ] ].

    isEvenEvent ifTrue: [
        whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ] ].

    isEvenEvent := isEvenEvent not
]

{ #category : 'initialization' }
RadioGroupPresenter >> connectPresenters [ 
    | block |
    block := [ self buttonStateChanged ].
    buttons do: [ :btn | btn mainPresenter whenChangedDo: block ].
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> correctIndexToFirst [ 
    index := 1.
    whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ].
]

{ #category : 'accessing' }
RadioGroupPresenter >> indexSelected [ 
    ^ index
]

{ #category : 'initialization' }
RadioGroupPresenter >> initialize [ 
    super initialize.
    index := 1.
    isEvenEvent := false.
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> itemSelected [ 
    ^ items at: index ifAbsent: [ nil ]
]

{ #category : 'updating' }
RadioGroupPresenter >> updateButtons [

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
    whenIndexChangedDo := aBlock
]
