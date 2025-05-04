Class {
	#name : 'RadioGroupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'title',
		'items',
		'buttons',
		'display',
		'columnCount',
		'index',
		'whenIndexChangedDo',
		'isEvenEvent',
		'isScrollable'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
RadioGroupPresenter class >> defaultItems [
   ^ #( 'Button 1' 'Button 2' 'Button 3' ).
]

{ #category : 'adding' }
RadioGroupPresenter >> addItem: anObject [
   items add: anObject.
   self updateButtons.
   (buttons at: index) state: true.
   self connectPresenters; updateCurrentLayout.
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> buildColumnLayout: aColumnCount [

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

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> buttonStateChanged [

	buttons withIndexDo: [ :btn :ind |
		btn mainPresenter state ifTrue: [ index := ind ] ].
	isEvenEvent ifTrue: [
		whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ] ].
	isEvenEvent := isEvenEvent not
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> columnCount [
   ^ columnCount.
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> connectPresenters [

	| block |
	block := [ self buttonStateChanged ].
	buttons do: [ :btn | btn mainPresenter whenChangedDo: block ]
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> correctIndexToFirst [
   index := 1.
   whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ].
]

{ #category : 'accessing' }
RadioGroupPresenter >> disableButtonAt: anIndex [

	| button |
	anIndex > 0 ifFalse: [ ^ self ].
	button := buttons at: anIndex ifAbsent: [ ^ self ].
	button mainPresenter enabled: false
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> display: aBlock [
   display := aBlock.
   self updateLabels.
]

{ #category : 'accessing' }
RadioGroupPresenter >> enableButtonAt: anIndex [

	| button |
	anIndex > 0 ifFalse: [ ^ self ].
	button := buttons at: anIndex ifAbsent: [ ^ self ].
	button mainPresenter enabled: true
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> enableScrolling: aBoolean [ 
	isScrollable := aBoolean.
	self updateCurrentLayout.
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> generateLayout [

	| layoutContent result |
	layoutContent := columnCount = 1
		                 ifTrue: [ self buildColumnLayout: 1 ]
		                 ifFalse: [ self buildColumnLayout: columnCount ].

	result := layoutContent.
	isScrollable ifTrue: [
			| scroll |
			scroll := SpScrollableLayout new.
			scroll child: layoutContent.
			result := scroll ].

	^ self title ifNil: [ result ] ifNotNil: [
			  SpFrameLayout new
				  label: self title;
				  add: result;
				  yourself ]
]

{ #category : 'accessing - deprecated' }
RadioGroupPresenter >> hideTitle [
   self title: String empty.

]

{ #category : 'accessing' }
RadioGroupPresenter >> indexSelected [ 
    ^ index
]

{ #category : 'initialization' }
RadioGroupPresenter >> initialize [

	isEvenEvent := false.
	index := 1.
	isScrollable := false.
	items ifNil: [ items := self class defaultItems ].
	display := [ :object | object asStringOrText ].
	columnCount := 1.
	super initialize
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> initializePresenters [

	title := LabelPresenter new.
	title text: self class title.
	self updateButtons.
	self updateCurrentLayout 
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> itemSelected [
   ^ items at: index.
]

{ #category : 'accessing' }
RadioGroupPresenter >> items: aCollection [
   | size |
   size := items size.
   items := aCollection asOrderedCollection.
   size = aCollection size
      ifTrue: [ self updateLabels ]
      ifFalse: [ self updateButtons; connectPresenters;
                   updateCurrentLayout; correctIndexToFirst ].
]

{ #category : 'removing' }
RadioGroupPresenter >> removeItem: anObject [
   | keepIndex |
   keepIndex := anObject ~= self itemSelected.
   items remove: anObject.
   self updateButtons.
   keepIndex ifTrue: [ (buttons at: index) state: true.
         self connectPresenters; updateCurrentLayout ]
      ifFalse: [ self connectPresenters;
         updateCurrentLayout; correctIndexToFirst ].
]

{ #category : 'accessing - model' }
RadioGroupPresenter >> setModelBeforeInitialization: aCollection [
   items := aCollection asOrderedCollection.
]

{ #category : 'accessing - deprecated' }
RadioGroupPresenter >> title [

	^ title text
]

{ #category : 'accessing' }
RadioGroupPresenter >> title: aString [

	aString ifNil: [ title := nil ] ifNotNil: [
			title ifNil: [ title := self newLabel ].
			title text: aString ].
	self updateCurrentLayout
]

{ #category : 'updating' }
RadioGroupPresenter >> updateButtons [

	| firstButton presenters |
	firstButton := RadioButtonPresenter new.
	buttons := OrderedCollection with: firstButton.
	items allButFirstDo: [ :object |
		buttons add: RadioButtonPresenter new ].
	presenters := buttons allButFirst collect: [ :b | b mainPresenter ].
	firstButton mainPresenter associatedRadioButtons: presenters.
	self updateLabels
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> updateCurrentLayout [

	self layout: self generateLayout.
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> updateLabels [

	buttons withIndexDo: [ :btn :ind |
		btn mainPresenter label: (display value: (items at: ind)) ]
]

{ #category : 'accessing' }
RadioGroupPresenter >> whenIndexChangedDo: aBlock [
   whenIndexChangedDo := aBlock.
]

{ #category : 'initialization' }
RadioGroupPresenter >> сolumnCount: aNumber [

	columnCount := aNumber max: 1.
	self updateCurrentLayout
]
