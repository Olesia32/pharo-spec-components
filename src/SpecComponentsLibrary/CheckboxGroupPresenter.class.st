"
I am a presenter that displays a group of checkboxes arranged in a configurable layout.  
I support multiple selection, scrollable layout, column-based arrangement, and optional visual decorations such as a frame and title.  
Each checkbox represents an item from the list. Users can select or deselect multiple items, and selection changes are reported via an event.

### Hierarchy

`SpAbstractPresenter`  
  `SpPresenter` 
    `AbstractSelectableGroupPresenter`  
      `CheckboxGroupPresenter` (this is me)

### Instance Variables

- _selectedIndexes_: a `Set` — stores the indexes of selected checkboxes
- _whenSelectionChangedDo_: a `BlockClosure` — optional callback executed when the selection changes

### Public API

- `CheckboxGroupPresenter>>#selectedIndexes` — returns the list of selected indexes in sorted order
- `CheckboxGroupPresenter>>#selectedItems` — returns the corresponding items for selected indexes
- `CheckboxGroupPresenter>>#clearSelection` — deselects all checkboxes
- `CheckboxGroupPresenter>>#isCheckedAt:` — returns whether the checkbox at the given index is selected

### Events

- `CheckboxGroupPresenter>>#whenSelectionChangedDo:` — sets a callback block for selection change

### Usage

To use this component, provide it with a list of items and optionally configure its layout:

```smalltalk
| group |
group := CheckboxGroupPresenter new.
group items: #( 'Red' 'Green' 'Blue' 'Yellow' ).
group сolumnCount: 2.
group showFrame: true.
group whenSelectionChangedDo: [ :selected | Transcript show: selected printString; cr ].
group open.


"
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
		ifFalse: [ selectedIndexes remove: index ].

	whenSelectionChangedDo ifNotNil: [
		whenSelectionChangedDo value: self selectedIndexes ]
]

{ #category : 'accessing' }
CheckboxGroupPresenter >> whenSelectionChangedDo: aBlock [
"Sets the callback block to be executed each time the selection changes."
	whenSelectionChangedDo := aBlock
]
