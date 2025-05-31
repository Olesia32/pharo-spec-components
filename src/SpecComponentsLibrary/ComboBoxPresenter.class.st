"
I am a dropdown component with filterable text input. I display a list of selectable items and update the text field based on selection. The dropdown opens as a floating morph above other UI components.

### Hierarchy

`SpAbstractPresenter`  
`SpPresenter`  
`AbstractDropdownPresenter`  
`ComboBoxPresenter` (this is me)

### Instance Variables

- _selectedIndex_: an `Integer` — the index of the currently selected item in the original item list

### Public API

- `ComboBoxPresenter>>#items:` — sets the full list of items and updates the filtered list
- `ComboBoxPresenter>>#selectedIndex` — gets the index of the currently selected item
- `ComboBoxPresenter>>#selectedItem` — returns the currently selected item from the original list
- `ComboBoxPresenter>>#selectIndex:` — selects the item by index and updates the input field accordingly

### Usage

To use a `ComboBoxPresenter`, create an instance, set the list of items, and open it in a window:

```smalltalk
| combo |
combo := ComboBoxPresenter new.
combo items: #( 'Apple' 'Banana' 'Orange' 'Pear' ).
combo openInWindow.

"
Class {
	#name : 'ComboBoxPresenter',
	#superclass : 'AbstractDropdownPresenter',
	#category : 'SpecComponentsLibrary-Dropdown',
	#package : 'SpecComponentsLibrary',
	#tag : 'Dropdown'
}

{ #category : 'initialization' }
ComboBoxPresenter >> connectPresenters [
"Connects the text input to the filtering logic. The list is updated every time the user types."
	textInput mainPresenter whenTextChangedDo: [ self filterList ]
]

{ #category : 'private' }
ComboBoxPresenter >> createMorphList [
"Creates and returns a PluggableListMorph connected to the filteredItems and selectedIndex.
Used to display the dropdown as a floating morph."
	^ PluggableListMorph
		  on: self
		  list: #filteredItems
		  selected: #selectedIndex
		  changeSelected: #selectIndex:
]

{ #category : 'private' }
ComboBoxPresenter >> filterList [
"Filters the item list according to the current text input (case-insensitive).
If the exact match is found — it becomes selected.
If the dropdown is open, it refreshes its content to reflect the filter."
	| tmp1 tmp2 |
	tmp1 := textInput text asLowercase.
	filteredItems := allItems select: [ :arg1 |
		                 arg1 asString asLowercase includesSubstring: tmp1 ].
	tmp2 := filteredItems
		        detect: [ :arg2 | arg2 asString = textInput text ]
		        ifNone: [ ].
	selectedIndex := tmp2
		                 ifNil: [ 0 ]
		                 ifNotNil: [ allItems indexOf: tmp2 ifAbsent: 0 ].
	isOpen ifFalse: [ ^ self ].
	self
		closeMorphList;
		openMorphList
]

{ #category : 'initialization' }
ComboBoxPresenter >> initialize [

	super initialize.
	selectedIndex := 0
]

{ #category : 'initialization' }
ComboBoxPresenter >> initializePresenters [

	super initializePresenters
]

{ #category : 'accessing' }
ComboBoxPresenter >> items: arg1 [
"Sets the full list of items, updates the filtered list and applies the current filter immediately."
	super items: arg1.
	filteredItems := allItems.
	self filterList
]

{ #category : 'accessing' }
ComboBoxPresenter >> selectIndex: anIndex [
	"Updates the selectedIndex and fills the text input with the selected item's string.
Also triggers a selection event and closes the dropdown."
	selectedIndex := anIndex.

	(anIndex between: 1 and: filteredItems size) ifTrue: [
		| item |
		item := filteredItems at: anIndex.
		textInput text: item asString.
		announcer announce: (ComboBoxItemSelected new item: item)
	].

	self closeMorphList.
	isOpen := false.
	self updateToggleButtonIcon.
]

{ #category : 'accessing' }
ComboBoxPresenter >> selectedIndex [
"Returns the index of the currently selected item."
	^ selectedIndex
]

{ #category : 'accessing' }
ComboBoxPresenter >> selectedItem [
"Returns the selected item from the original (unfiltered) list based on selectedIndex."
	^ allItems at: selectedIndex
]
