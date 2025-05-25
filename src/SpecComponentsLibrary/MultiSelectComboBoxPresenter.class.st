"
I am a dropdown presenter that supports multiple selection using checkboxes.  
I consist of a filterable text input and a dropdown list of checkboxes.  
Users can type to filter items, select multiple values, and see their selection reflected in the input field.  
Selection changes trigger event notifications.

### Hierarchy

`SpAbstractPresenter`  
  `SpPresenter`  
    `AbstractDropdownPresenter`  
      `MultiSelectComboBoxPresenter` (this is me)

### Instance Variables

- _selectedItems_: a `Set` — holds currently selected items
- _checkboxes_: a `Dictionary` — maps items to their corresponding checkbox presenters
- _listPresenter_: a `SpComponentListPresenter` — displays the list of checkboxes as components

### Public API

- `MultiSelectComboBoxPresenter>>#items:` — sets the list of selectable items and resets selection
- `MultiSelectComboBoxPresenter>>#selectedItems` — returns the set of currently selected items
- `MultiSelectComboBoxPresenter>>#selectedIndexes:` — selects items by their indexes in the `allItems` list

### Events

- `MultiSelectComboBoxPresenter>>#whenSelectionChangedDo:` — registers an event handler that receives the updated set of selected items

### Usage

To use a `MultiSelectComboBoxPresenter`, create an instance, set the items, and open it in a window:

```smalltalk
| multiCombo |
multiCombo := MultiSelectComboBoxPresenter new.
multiCombo items: #( 'One' 'Two' 'Three' 'Four' ).
multiCombo whenSelectionChangedDo: [ :selection | 
  Transcript show: 'Selected: ', selection asArray printString; cr ].
multiCombo open.

"
Class {
	#name : 'MultiSelectComboBoxPresenter',
	#superclass : 'AbstractDropdownPresenter',
	#instVars : [
		'selectedItems',
		'checkboxes',
		'listPresenter'
	],
	#category : 'SpecComponentsLibrary-Dropdown',
	#package : 'SpecComponentsLibrary',
	#tag : 'Dropdown'
}

{ #category : 'initialization' }
MultiSelectComboBoxPresenter >> connectPresenters [
"Connects the text input field to the filtering logic and the toggle button to the list visibility handler."
	textInput mainPresenter whenTextChangedDo: [ self filterList ].
	toggleButton onClick: [ self toggleList ]
]

{ #category : 'private' }
MultiSelectComboBoxPresenter >> createMorphList [
"Creates and returns the dropdown morph displaying the checkbox list.
If already created, returns the existing one. Updates the list before returning."
	morphList ifNotNil: [ ^ morphList := listPresenter adapter widget ].
	self updateListWith: filteredItems.
	listPresenter build.
	morphList := listPresenter adapter widget.
	^ morphList
]

{ #category : 'private' }
MultiSelectComboBoxPresenter >> filterList [
"Filters allItems based on the current text input (case-insensitive).
Rebuilds the checkbox list with the filtered results."
	| tmp1 |
	tmp1 := textInput text asLowercase.
	filteredItems := allItems select: [ :arg1 |
		                 arg1 asString asLowercase includesSubstring: tmp1 ].
	self updateListWith: filteredItems
]

{ #category : 'initialization' }
MultiSelectComboBoxPresenter >> initialize [ 
    super initialize.
    selectedItems := Set new.
    checkboxes := Dictionary new.
]

{ #category : 'initialization' }
MultiSelectComboBoxPresenter >> initializePresenters [

	super initializePresenters.
	listPresenter := SpComponentListPresenter new.
	textInput mainPresenter placeholder: 'Фільтр...'
]

{ #category : 'api' }
MultiSelectComboBoxPresenter >> items: arg1 [
"Sets the full list of items. Clears the current selection and triggers initial filtering."
	super items: arg1.
	selectedItems := Set new.
	self filterList
]

{ #category : 'api' }
MultiSelectComboBoxPresenter >> selectedIndexes: anIndexList [
"Selects items by their indexes in allItems.
Updates internal state, refreshes the list, announces selection, and updates the input field."
	selectedItems := Set new.

	anIndexList do: [ :index |
			(index between: 1 and: allItems size) ifTrue: [
					| item |
					item := allItems at: index.
					selectedItems add: item ] ].

	self updateListWith: filteredItems.
	announcer announce: (ComboBoxItemSelected new item: selectedItems).
	self updateFieldContent
]

{ #category : 'accessing' }
MultiSelectComboBoxPresenter >> selectedItems [

	^ selectedItems
]

{ #category : 'private' }
MultiSelectComboBoxPresenter >> toggleList [
"Toggles the visibility of the dropdown list.
Also updates the input field to show or clear the summary of selected items."
	super toggleList.
	self updateFieldContent
]

{ #category : 'private' }
MultiSelectComboBoxPresenter >> updateFieldContent [
"When the dropdown is closed, displays selected items as comma-separated text.
When opened, clears the field for filtering."
	isOpen
		ifFalse: [
				textInput text: (String streamContents: [ :stream |
							 self selectedItems asArray sort doWithIndex: [ :each :i |
									 stream nextPutAll: each.
									 i < self selectedItems size ifTrue: [
										 stream nextPutAll: ', ' ] ] ]) ]
		ifTrue: [ textInput text: '' ]
]

{ #category : 'private' }
MultiSelectComboBoxPresenter >> updateListWith: arg1 [
"Builds a checkbox list for the given collection of items.
Each checkbox is tied to a selection change handler that updates the internal state and sends a selection event."
	checkboxes := Dictionary new.
	listPresenter ifNil: [ ^ self ].
	listPresenter items: #(  ).
	arg1 do: [ :arg2 |
			| tmp1 tmp3 |
			tmp1 := CheckboxPresenter new.
			tmp3 := tmp1 mainPresenter.
			tmp3
				label: arg2 asString;
				state: (selectedItems includes: arg2);
				whenChangedDo: [ :arg3 |
						arg3
							ifTrue: [ selectedItems add: arg2 ]
							ifFalse: [ selectedItems remove: arg2 ].
						announcer announce:
								(ComboBoxItemSelected new item: selectedItems) ].
			checkboxes at: arg2 put: tmp1.
			listPresenter addPresenter: tmp1 ].
	listPresenter build.
	morphList ifNotNil: [
			self closeMorphList.
			morphList := listPresenter adapter widget.
			self openMorphList ]
]

{ #category : 'events' }
MultiSelectComboBoxPresenter >> whenSelectionChangedDo: aBlock [
"Registers an event handler that will be triggered when the selection changes."
	announcer
		when: ComboBoxItemSelected
		do: [ :evt | aBlock value: evt item ]
		for: self
]
