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
		'isEvenEvent'
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
RadioGroupPresenter >> conditionalLayout: aBlock [

	| frame |
	self title ifNil: [ ^ aBlock value ].

	frame := SpFrameLayout new.
	frame label: self title.
	frame add: aBlock value.
	^ frame
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

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> defaultLayout [

	| frame content |
	content := columnCount = 1
		           ifTrue: [ self singleColumnLayout ]
		           ifFalse: [ self multipleColumnLayout ].

	frame := SpFrameLayout new.
	frame label: title.
	frame add: (SpPresenter new layout: content).
	^ frame yourself
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> display: aBlock [
   display := aBlock.
   self updateLabels.
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
	self layout: self defaultLayout.
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

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> multipleColumnLayout [

	| size hBoxLayout vBoxLayout high begin end |
	hBoxLayout := SpBoxLayout newLeftToRight.
	size := buttons size.
	high := size + columnCount - 1 // columnCount.
	begin := 1 - high.
	end := 0.
	columnCount timesRepeat: [
			vBoxLayout := SpBoxLayout newTopToBottom.
			begin := begin + high.
			end := end + high.
			begin to: (end min: size) do: [ :i |
			vBoxLayout add: (buttons at: i) ].
			hBoxLayout add: vBoxLayout ].
	end - size timesRepeat: [ vBoxLayout add: LabelPresenter new ].
	^ hBoxLayout
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

{ #category : 'initialization' }
RadioGroupPresenter >> setColumnCount: aNumber [
   columnCount := aNumber max: 1.
   self updateCurrentLayout.
]

{ #category : 'accessing - model' }
RadioGroupPresenter >> setModelBeforeInitialization: aCollection [
   items := aCollection asOrderedCollection.
]

{ #category : 'as yet unclassified' }
RadioGroupPresenter >> singleColumnLayout [
   | boxLayout |
   boxLayout := SpBoxLayout newTopToBottom.
   buttons do: [ :btn | boxLayout add: btn ].
   ^ boxLayout.
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
   columnCount = 1
      ifTrue: [ self layout: (self conditionalLayout: [ self singleColumnLayout ]) ]
      ifFalse: [ self layout: (self conditionalLayout: [ self multipleColumnLayout ]) ].
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
