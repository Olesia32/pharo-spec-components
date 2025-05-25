"
I am an abstract presenter for building button groups such as checkboxes or radio buttons.  
I provide reusable logic for displaying items in one or multiple columns with optional title, frame, and scrollable layout.  
Each item is rendered as a button (created via `#buildButton`) and can be customized via display and layout settings.

### Instance Variables

- _title_: a `LabelPresenter` — optional title displayed above or inside a frame
- _items_: an `OrderedCollection` — the collection of values represented by buttons
- _buttons_: a `Collection` — the list of rendered buttons
- _display_: a `BlockClosure` — defines how to convert items into button labels
- _columnCount_: an `Integer` — number of columns for arranging the buttons
- _isScrollable_: a `Boolean` — whether the group should be scrollable
- _showFrame_: a `Boolean` — whether to wrap the group in a frame
- _showTitle_: a `Boolean` — whether to show the title label above the group

### Public API

- `AbstractSelectableGroupPresenter>>#items:` — sets or updates the item collection and regenerates the group
- `AbstractSelectableGroupPresenter>>#addItem:` — adds a new item to the group
- `AbstractSelectableGroupPresenter>>#removeItem:` — removes an item and updates layout
- `AbstractSelectableGroupPresenter>>#itemAtIndex:` — retrieves an item by index
- `AbstractSelectableGroupPresenter>>#title`, `>>#title:` — gets or sets the group’s title text
- `AbstractSelectableGroupPresenter>>#сolumnCount:` — sets the number of layout columns (minimum 1)
- `AbstractSelectableGroupPresenter>>#display:` — sets a block to customize how items are displayed
- `AbstractSelectableGroupPresenter>>#enableButtonAt:`, `AbstractSelectableGroupPresenter>>#disableButtonAt:` — enables or disables a button by index
- `AbstractSelectableGroupPresenter>>#enableScrolling:` — toggles scrollability
- `AbstractSelectableGroupPresenter>>#showFrame:`, `>>#showTitle:` — controls visibility of the frame and title

### Usage

This class is abstract and meant to be subclassed by components like `CheckboxGroupPresenter` or `RadioGroupPresenter`.  
The subclass is responsible for implementing _buildButton_ to define the type of button used (e.g., checkbox or radiobutton),  
and _handleItemClickAt:_ for handling user interactions.

Example subclass responsibilities:
- _buildButton_ → returns a specific presenter like `CheckboxPresenter`
- _connectPresenters_ → sets up change handlers
- _handleItemClickAt:_ → responds to selection

Layout, labeling, and updates are handled by the superclass.

"
Class {
	#name : 'AbstractSelectableGroupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'title',
		'items',
		'buttons',
		'display',
		'columnCount',
		'isScrollable',
		'showFrame',
		'showTitle'
	],
	#category : 'SpecComponentsLibrary-Groups',
	#package : 'SpecComponentsLibrary',
	#tag : 'Groups'
}

{ #category : 'initialization' }
AbstractSelectableGroupPresenter class >> defaultItems [ 
    ^ #( 'Button 1' 'Button 2' 'Button 3' )
]

{ #category : 'testing' }
AbstractSelectableGroupPresenter class >> isAbstract [ 
    ^ true
]

{ #category : 'adding' }
AbstractSelectableGroupPresenter >> addItem: anObject [
"Adds a new item to the group and refreshes the buttons and layout."
	items add: anObject.
	self updateButtons.
	self connectPresenters.
	self updateCurrentLayout
]

{ #category : 'building' }
AbstractSelectableGroupPresenter >> buildButton [
	"Abstract method. Subclasses must implement this to create the appropriate button type."

	
]

{ #category : 'building' }
AbstractSelectableGroupPresenter >> buildColumnLayout: aColumnCount [
"Arranges buttons into the given number of columns using vertical stacks inside a horizontal layout.
If only one column is requested, a single vertical layout is returned."
	| singleLayout totalRows hLayout |
	aColumnCount = 1 ifTrue: [
			singleLayout := SpBoxLayout newTopToBottom.
			buttons do: [ :btn | singleLayout add: btn ].
			^ singleLayout yourself ].

	totalRows := buttons size + aColumnCount - 1 // aColumnCount.
	hLayout := SpBoxLayout newLeftToRight.
	1 to: aColumnCount do: [ :col |
			| vLayout start end |
			vLayout := SpBoxLayout newTopToBottom.
			start := col - 1 * totalRows + 1.
			end := start + totalRows - 1 min: buttons size.
			start to: end do: [ :i | vLayout add: (buttons at: i) ].
			hLayout add: vLayout ].
	^ hLayout
]

{ #category : 'initialization' }
AbstractSelectableGroupPresenter >> connectPresenters [
	"Empty by default. Subclasses should use this to attach event handlers to buttons."

	
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> disableButtonAt: anIndex [
"Disables the button at the given index, if it exists."
	| button |
	anIndex > 0 ifFalse: [ ^ self ].
	button := buttons at: anIndex ifAbsent: [ ^ self ].
	button mainPresenter enabled: false
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> display: aBlock [
"Sets the block used to convert items to display labels and updates button labels accordingly."
	display := aBlock.
	self updateLabels
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> enableButtonAt: anIndex [
"Enables the button at the given index, if it exists."
	| button |
	anIndex > 0 ifFalse: [ ^ self ].
	button := buttons at: anIndex ifAbsent: [ ^ self ].
	button mainPresenter enabled: true
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> enableScrolling: aBoolean [
"Enables or disables scrolling for the group layout and rebuilds the layout."
	isScrollable := aBoolean.
	self updateCurrentLayout
]

{ #category : 'private' }
AbstractSelectableGroupPresenter >> generateLayout [
"Builds the layout based on the number of columns, scroll setting, and whether the frame or title is shown.
Combines column layout with optional frame or title placement."
	| tmp1 tmp2 tmp3 tmp4 |
	tmp1 := columnCount = 1
		        ifTrue: [ self buildColumnLayout: 1 ]
		        ifFalse: [ self buildColumnLayout: columnCount ].
	tmp2 := isScrollable
		        ifTrue: [ SpScrollableLayout new child: tmp1 ]
		        ifFalse: [ tmp1 ].
	tmp3 := (showFrame and: showTitle)
		        ifTrue: [
				        | tmp5 |
				        tmp5 := SpFrameLayout new.
				        tmp5
					        label: self title;
					        add: tmp2;
					        yourself ]
		        ifFalse: (showFrame
				         ifTrue: [
						         | tmp6 |
						         tmp6 := SpFrameLayout new.
						         tmp6
							         add: tmp2;
							         yourself ]
				         ifFalse: (showTitle
						          ifTrue: [
								          tmp4 := SpBoxLayout newTopToBottom.
								          tmp4
									          spacing: 5;
									          add: title expand: false;
									          add: tmp2;
									          yourself ]
						          ifFalse: [ tmp2 ])).
	^ tmp3
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> handleItemClickAt: index [
	"Abstract hook for subclasses to handle clicks on specific items."

	
]

{ #category : 'initialization' }
AbstractSelectableGroupPresenter >> initialize [

	isScrollable := false.
	columnCount := 1.
	showFrame := false.
	showTitle := false.
	items := self class defaultItems.
	display := [ :object | object asStringOrText ].
	super initialize
]

{ #category : 'initialization' }
AbstractSelectableGroupPresenter >> initializePresenters [ 
    title := LabelPresenter new.
    title text: self class title.
    self updateButtons.
    self updateCurrentLayout
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> itemAtIndex: anIndex [
"Returns the item at the given index or nil if out of bounds."
	^ items at: anIndex ifAbsent: [ nil ]
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> items: aCollection [
"Sets a new item collection.
If the size is the same as the previous one, only labels are updated; otherwise buttons are rebuilt."
	| sameSize |
	sameSize := items size = aCollection size.
	items := aCollection asOrderedCollection.
	sameSize
		ifTrue: [ self updateLabels ]
		ifFalse: [
				self
					updateButtons;
					connectPresenters;
					updateCurrentLayout ]
]

{ #category : 'removing' }
AbstractSelectableGroupPresenter >> removeItem: anObject [
"Removes an item from the collection and refreshes the buttons and layout."
	items remove: anObject.
	self updateButtons.
	self connectPresenters.
	self updateCurrentLayout
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> showFrame: aBoolean [
"Enables or disables the frame layout around the group and refreshes layout."
	showFrame := aBoolean.
	self updateCurrentLayout
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> showTitle: aBoolean [
"Enables or disables the title display and refreshes layout."
	showTitle := aBoolean.
	self updateCurrentLayout
]

{ #category : 'accessing - deprecated' }
AbstractSelectableGroupPresenter >> title [
"Returns the current title text."
	^ title text
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> title: aString [
"Sets the title label’s text. Creates the label if necessary and updates the layout."
	aString ifNil: [ title := nil ] ifNotNil: [
			title ifNil: [ title := self newLabel ].
			title text: aString ].
	self updateCurrentLayout
]

{ #category : 'updating' }
AbstractSelectableGroupPresenter >> updateButtons [
"Regenerates buttons based on current items and updates their labels."
	buttons := items collect: [ :each | self buildButton ].
	self updateLabels
]

{ #category : 'updating' }
AbstractSelectableGroupPresenter >> updateCurrentLayout [
"Applies the current layout configuration using generateLayout."
	self layout: self generateLayout
]

{ #category : 'updating' }
AbstractSelectableGroupPresenter >> updateLabels [
"Updates button labels using the current display block."
	buttons withIndexDo: [ :btn :ind |
		btn mainPresenter label: (display value: (items at: ind)) ]
]

{ #category : 'api' }
AbstractSelectableGroupPresenter >> сolumnCount: aNumber [
"Sets the number of columns and refreshes layout.
Ensures that column count is at least 1."
	columnCount := aNumber max: 1.
	self updateCurrentLayout
]
