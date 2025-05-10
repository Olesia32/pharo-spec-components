"
Презентер для відображення групи радіокнопок (Radio Button).

Забезпечує вибір одного елемента з колекції, підтримує заголовок, рамку, кількість колонок і реакцію на зміну вибору.

"
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
    ^ RadioButtonPresenter new
]

{ #category : 'events' }
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

{ #category : 'private' }
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

{ #category : 'accessing' }
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
