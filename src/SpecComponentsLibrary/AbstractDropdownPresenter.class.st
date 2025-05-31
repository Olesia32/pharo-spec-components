"
I am an abstract dropdown presenter used as a base for dropdown components.
I provide common structure: a text input for filtering, a toggle button, and a floating list morph.
My subclasses must define how the list is created, filtered and connected.

### Instance Variables

- _textInput_: a `TextInputPresenter` provides a filter field to narrow down the list
- _toggleButton_: a `ButtonPresenter` toggles the visibility of the dropdown list
- _list_: a `SpPresenter` placeholder for the list presenter (defined by subclass)
- _allItems_: a `Collection` holds all available items before filtering
- _isOpen_: a `Boolean` indicates whether the dropdown is currently open
- _morphList_: a `Morph` floating morph used to render the dropdown list
- _filteredItems_: a `Collection` items that match the current filter text
- _selectedIndex_: an `Integer` index of the currently selected item

### Public API

- `AbstractDropdownPresenter>>#items:` — sets the complete list of items. Nil values will be removed.
- `AbstractDropdownPresenter>>#selectedIndex`, `AbstractDropdownPresenter>>#selectedIndex:` — gets or sets the index of the selected item.
- `AbstractDropdownPresenter>>#filteredItems`, `AbstractDropdownPresenter>>#filteredItems:` — gets or sets the filtered list.
- `AbstractDropdownPresenter>>#textInput` — gets filter field.

### Events

- `AbstractDropdownPresenter>>#whenSelectionChangedDo:` — registers an event handler that receives the selected item

### Usage

This class is abstract. To use it, subclass it and implement:
- `AbstractDropdownPresenter>>#createMorphList` — to define the morph shown on toggle.
- `AbstractDropdownPresenter>>#filterList` — to filter the items based on textInput.
- `AbstractDropdownPresenter>>#connectPresenters` — to wire list interactions.
"
Class {
	#name : 'AbstractDropdownPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textInput',
		'toggleButton',
		'list',
		'allItems',
		'isOpen',
		'morphList',
		'filteredItems',
		'selectedIndex'
	],
	#category : 'SpecComponentsLibrary-Dropdown',
	#package : 'SpecComponentsLibrary',
	#tag : 'Dropdown'
}

{ #category : 'testing' }
AbstractDropdownPresenter class >> isAbstract [ 
^ true
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> allItems [
	"Returns the complete unfiltered collection of items available for selection."

	^ allItems
]

{ #category : 'private' }
AbstractDropdownPresenter >> announceSelectionWith: arg1 [
"Announces a selection change by broadcasting a ComboBoxItemSelected event with the given item."

	announcer announce: (ComboBoxItemSelected new item: arg1)
]

{ #category : 'private' }
AbstractDropdownPresenter >> closeMorphList [
"Closes and removes the dropdown morph if it is currently open."
	morphList ifNotNil: [
			morphList delete.
			morphList := nil ]
]

{ #category : 'initialization' }
AbstractDropdownPresenter >> connectPresenters [
"Abstract method. Subclasses must connect interaction logic between presenters (e.g., hook text changes to filtering)."
	self subclassResponsibility
]

{ #category : 'private' }
AbstractDropdownPresenter >> createListPresenter [
"Creates a basic list presenter. Subclasses may override this method to return a more specific component list."

	^ SpPresenter new 
]

{ #category : 'private' }
AbstractDropdownPresenter >> createMorphList [
"Abstract method. Subclasses must define how the morphic dropdown list is constructed."
	self subclassResponsibility
]

{ #category : 'layout' }
AbstractDropdownPresenter >> defaultLayout [

	| tmp1 tmp2 |
	tmp2 := SpBoxLayout newLeftToRight.
	tmp2 add: textInput mainPresenter.
	tmp1 := SpBoxLayout new add:
		        (tmp2 add: toggleButton withConstraints: [ :arg1 |
				         arg1
					         width: 25;
					         expand: false ]).
	^ tmp1
]

{ #category : 'private' }
AbstractDropdownPresenter >> filterList [
"Abstract method. Subclasses must implement filtering logic based on user input."
	self subclassResponsibility
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> filteredItems [
"Returns the current collection of filtered items that match the user’s input."
	^ filteredItems
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> filteredItems: arg1 [
"Sets the filtered items collection to the given value."
	filteredItems := arg1
]

{ #category : 'initialization' }
AbstractDropdownPresenter >> initialize [

	super initialize.
	allItems := #(  ).
	filteredItems := #(  ).
	announcer := Announcer new.
	isOpen := false
]

{ #category : 'initialization' }
AbstractDropdownPresenter >> initializePresenters [

	textInput := TextInputPresenter new.
	toggleButton := ButtonPresenter new.
	toggleButton onClick: [ self toggleList ].
	isOpen := false.
	self updateToggleButtonIcon
]

{ #category : 'api' }
AbstractDropdownPresenter >> items: arg1 [
"Sets the full list of selectable items, discarding any nil entries."

	allItems := arg1 reject: [ :arg2 | arg2 isNil ]
]

{ #category : 'private' }
AbstractDropdownPresenter >> openMorphList [
	"Creates and displays the dropdown morph below the text input field with the correct size and position."

	| tmp1 tmp2 listBottom windowBottom extraHeight wnd |
	morphList := self createMorphList.
	morphList color: Color white.
	tmp1 := textInput mainPresenter adapter widget bounds.
	tmp2 := textInput mainPresenter adapter widget width.
	morphList
		width: tmp2;
		position: tmp1 bottomLeft;
		height: 100.
	wnd := self window window.
	wnd addMorph: morphList.
	listBottom := tmp1 bottom + 100.
	windowBottom := wnd bounds bottom.
	extraHeight := listBottom - windowBottom.
	extraHeight > 0 ifTrue: [ wnd height: wnd height + extraHeight + 10 ].
	morphList comeToFront
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> selectedIndex [
"Returns the index of the currently selected item."
	^ selectedIndex
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> selectedIndex: anObject [
"Sets the selected item index."
	selectedIndex := anObject
]

{ #category : 'accessing' }
AbstractDropdownPresenter >> textInput [
^ textInput 
]

{ #category : 'private' }
AbstractDropdownPresenter >> toggleList [
"Opens or closes the dropdown list and updates the toggle button icon."
	isOpen
		ifTrue: [ self closeMorphList ]
		ifFalse: [ self openMorphList ].
	isOpen := isOpen not.
	self updateToggleButtonIcon
]

{ #category : 'private' }
AbstractDropdownPresenter >> updateToggleButtonIcon [
"Changes the icon on the toggle button depending on whether the list is open or closed."
	toggleButton mainPresenter icon: (self iconNamed: (isOpen
				  ifTrue: [ #arrowUp ]
				  ifFalse: [ #arrowDown ]))
]

{ #category : 'enumerating' }
AbstractDropdownPresenter >> whenSelectionChangedDo: aBlock [
"Registers an event handler that will be triggered when the user changes the selected item."
	announcer
		when: ComboBoxItemSelected
		do: [ :event | aBlock value: event item ]
		for: self
]
