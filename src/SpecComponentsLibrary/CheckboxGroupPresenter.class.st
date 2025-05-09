Class {
	#name : 'CheckboxGroupPresenter',
	#superclass : 'AbstractSelectableGroupPresenter',
	#instVars : [
		'selectedIndexes',
		'whenSelectionChangedDo'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'building' }
CheckboxGroupPresenter >> buildButton [ 
    ^ CheckboxPresenter new
]

{ #category : 'announcements' }
CheckboxGroupPresenter >> checkedItems [ 
    ^ selectedIndexes collect: [ :i | items at: i ifAbsent: nil ]
]

{ #category : 'resolution' }
CheckboxGroupPresenter >> clearSelection [ 
    selectedIndexes := Set new.
    buttons do: [ :btn | btn mainPresenter state: false ].
]

{ #category : 'initialization' }
CheckboxGroupPresenter >> connectPresenters [ 
    buttons withIndexDo: [ :btn :ind |
        btn mainPresenter whenChangedDo: [ self toggleSelectionAt: ind ] ]
]

{ #category : 'initialization' }
CheckboxGroupPresenter >> initialize [ 
    super initialize.
    selectedIndexes := Set new.
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> isCheckedAt: anIndex [ 
    ^ selectedIndexes includes: anIndex
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> selectedIndexes [ 
    ^ selectedIndexes asSortedCollection
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> selectedItems [

	^ selectedIndexes collect:
		  [ :i | items at: i ifAbsent: nil ] 
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> toggleSelectionAt: index [ 
    | buttonState |
    buttonState := (buttons at: index ifAbsent: [ ^ self ]) mainPresenter state.

    buttonState
        ifTrue: [ selectedIndexes add: index ]
        ifFalse: [ selectedIndexes remove: index ].

    whenSelectionChangedDo ifNotNil: [
        whenSelectionChangedDo value: self selectedIndexes ]
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> whenSelectionChangedDo: aBlock [ 
    whenSelectionChangedDo := aBlock
]
