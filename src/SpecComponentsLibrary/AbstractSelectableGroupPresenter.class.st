Class {
	#name : 'AbstractSelectableGroupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'title',
		'items',
		'buttons',
		'display',
		'columnCount',
		'isScrollable'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
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
    items add: anObject.
    self updateButtons.
    self connectPresenters.
    self updateCurrentLayout.
]

{ #category : 'building' }
AbstractSelectableGroupPresenter >> buildButton [ 
    "Перевизначається підкласом для створення потрібної кнопки"
]

{ #category : 'as yet unclassified' }
AbstractSelectableGroupPresenter >> buildColumnLayout: aColumnCount [

	|singleLayout totalRows hLayout |
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
    "Порожній — реалізується в підкласах"
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> disableButtonAt: anIndex [ 

	| button |
	anIndex > 0 ifFalse: [ ^ self ].
	button := buttons at: anIndex ifAbsent: [ ^ self ].
	button mainPresenter enabled: false
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> display: aBlock [ 
    display := aBlock.
    self updateLabels
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> enableButtonAt: anIndex [ 

	| button |
	anIndex > 0 ifFalse: [ ^ self ].
	button := buttons at: anIndex ifAbsent: [ ^ self ].
	button mainPresenter enabled: true
]

{ #category : 'as yet unclassified' }
AbstractSelectableGroupPresenter >> enableScrolling: aBoolean [ 
    isScrollable := aBoolean.
    self updateCurrentLayout
]

{ #category : 'as yet unclassified' }
AbstractSelectableGroupPresenter >> generateLayout [

	| layoutContent result |
	layoutContent := columnCount = 1
		                 ifTrue: [ self buildColumnLayout: 1 ]
		                 ifFalse: [ self buildColumnLayout: columnCount ].

	result := isScrollable
		          ifTrue: [ SpScrollableLayout new child: layoutContent ]
		          ifFalse: [ layoutContent ].

	^ title ifNil: [ result ] ifNotNil: [
			  SpFrameLayout new
				  label: self title;
				  add: result;
				  yourself ]
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> handleItemClickAt: index [ 
    "Цей метод буде перевизначено в підкласах"

]

{ #category : 'initialization' }
AbstractSelectableGroupPresenter >> initialize [

	isScrollable := false.
	columnCount := 1.
	items := self class defaultItems .
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
AbstractSelectableGroupPresenter >> items: aCollection [ 
    | sameSize |
    sameSize := items size = aCollection size.
    items := aCollection asOrderedCollection.
    sameSize ifTrue: [ self updateLabels ]
             ifFalse: [ self updateButtons; connectPresenters; updateCurrentLayout ].
]

{ #category : 'removing' }
AbstractSelectableGroupPresenter >> removeItem: anObject [ 
    items remove: anObject.
    self updateButtons.
    self connectPresenters.
    self updateCurrentLayout.
]

{ #category : 'accessing - deprecated' }
AbstractSelectableGroupPresenter >> title [ 
    ^ title text
]

{ #category : 'accessing' }
AbstractSelectableGroupPresenter >> title: aString [ 
    aString ifNil: [ title := nil ] ifNotNil: [
        title ifNil: [ title := self newLabel ].
        title text: aString ].
    self updateCurrentLayout
]

{ #category : 'updating' }
AbstractSelectableGroupPresenter >> updateButtons [ 
    buttons := items collect: [ :each | self buildButton ].
    self updateLabels.
]

{ #category : 'as yet unclassified' }
AbstractSelectableGroupPresenter >> updateCurrentLayout [ 
    self layout: self generateLayout
]

{ #category : 'as yet unclassified' }
AbstractSelectableGroupPresenter >> updateLabels [ 
    buttons withIndexDo: [ :btn :ind |
        btn mainPresenter label: (display value: (items at: ind)) ]
]

{ #category : 'initialization' }
AbstractSelectableGroupPresenter >> сolumnCount: aNumber [ 
    columnCount := aNumber max: 1.
    self updateCurrentLayout

]
