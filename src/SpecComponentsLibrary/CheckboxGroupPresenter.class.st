Class {
	#name : 'CheckboxGroupPresenter',
	#superclass : 'AbstractSelectableGroupPresenter',
	#instVars : [
		'selectedIndexes',
		'whenSelectionChangedDo'
	],
	#category : 'SpecComponentsLibrary-Groups',
	#package : 'SpecComponentsLibrary',
	#tag : 'Groups'
}

{ #category : 'building' }
CheckboxGroupPresenter >> buildButton [
"Creates and returns a new CheckboxPresenter for representing an item in the group."
	^ CheckboxPresenter new
]

{ #category : 'resolution' }
CheckboxGroupPresenter >> clearSelection [
"Deselects all checkboxes and clears the selectedIndexes set."
	selectedIndexes := Set new.
	buttons do: [ :btn | btn mainPresenter state: false ]
]

{ #category : 'initialization' }
CheckboxGroupPresenter >> connectPresenters [
"Connects each checkbox’s whenChangedDo: event to internal toggle logic.
Triggered whenever a checkbox is checked or unchecked."
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
"Returns true if the checkbox at the given index is selected."
	^ selectedIndexes includes: anIndex
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> selectedIndexes [
"Returns a sorted collection of the indexes corresponding to selected checkboxes."
	^ selectedIndexes asSortedCollection
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> selectedIndexes: aCollection [
    "Sets the selected checkboxes by index collection.
     Clears current selection and applies the new one."
    
    selectedIndexes := aCollection asSet.
    
    buttons withIndexDo: [ :btn :i |
        btn mainPresenter whenChangedDo: []. 
        btn mainPresenter state: (selectedIndexes includes: i) ].
    
    self connectPresenters.
    
    whenSelectionChangedDo ifNotNil: [
        whenSelectionChangedDo value: self selectedIndexes ]
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> selectedItems [
"Returns the actual data items corresponding to selectedIndexes."
	^ selectedIndexes collect: [ :i | items at: i ifAbsent: nil ]
]

{ #category : 'private' }
CheckboxGroupPresenter >> toggleSelectionAt: index [
	"Toggles the selection state of the checkbox at the given index.
Updates the internal selectedIndexes set and triggers the selectionChanged callback if present."

	| buttonState |
	buttonState := (buttons at: index ifAbsent: [ ^ self ]) mainPresenter
		               state.

	buttonState
		ifTrue: [ selectedIndexes add: index ]
		ifFalse: [
		selectedIndexes remove: index  ].

	whenSelectionChangedDo ifNotNil: [
		whenSelectionChangedDo value: self selectedIndexes ]
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> whenSelectionChangedDo: aBlock [
"Sets the callback block to be executed each time the selection changes."
	whenSelectionChangedDo := aBlock
]
