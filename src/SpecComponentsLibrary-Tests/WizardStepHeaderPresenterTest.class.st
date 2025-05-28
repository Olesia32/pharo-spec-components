Class {
	#name : 'WizardStepHeaderPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter',
		'canvasMock'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'running' }
WizardStepHeaderPresenterTest >> setUp [
	super setUp.
presenter := WizardStepHeaderPresenter new.
	canvasMock := presenter canvas.
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testActiveIndex [

	presenter activeIndex: 2.
	self assert: (presenter instVarNamed: 'activeIndex') equals: 2
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testBuildOuterCircleAtYColor [

	| shape |
	presenter radius: 20.
	shape := presenter buildOuterCircleAt: 50 y: 70 color: Color blue.
	self assert: shape class equals: RSEllipse.
	self assert: shape radius equals: 25.
	self assert: shape color equals: Color transparent.
	self assert: shape borderColor equals: Color blue darker.
	self assert: shape position equals: 50 @ 70
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testBuildStepCircleAtYColorBorderColor [

	| shape |
	presenter radius: 25.
	shape := presenter
		         buildStepCircleAt: 100
		         y: 200
		         color: Color red
		         borderColor: Color black.
	self assert: shape class equals: RSEllipse.
	self assert: shape radius equals: 25.5.
	self assert: shape color equals: Color red.
	self assert: shape borderColor equals: Color black.
	self assert: shape position equals: 100 @ 200
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testBuildStepLabelAtYTextFontSizeColor [

	| label |
	label := presenter
		         buildStepLabelAt: 10
		         y: 30
		         text: '3'
		         fontSize: 14
		         color: Color white.
	self assert: label class equals: RSLabel.
	self assert: label text equals: '3'.
	self assert: label fontSize equals: 14.
	self assert: label color equals: Color white.
	self assert: label position equals: 10 @ 30
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testBuildStepTitleAtYText [

	| label |
	presenter titleFontSize: 11.
	presenter titleColor: Color green.
	label := presenter buildStepTitleAt: 30 y: 60 text: 'Setup'.
	self assert: label class equals: RSLabel.
	self assert: label text equals: 'Setup'.
	self assert: label fontSize equals: 11.
	self assert: label color equals: Color green.
	self assert: label position equals: 30 @ 60
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testCenterXOfStepPlusRadius [

	presenter radius: 20. "stepSpacing becomes 140"
	self
		assert: (presenter centerXOfStep: 2 plusRadius: true)
		equals: 2 * 140 + 20.
	self
		assert: (presenter centerXOfStep: 2 plusRadius: false)
		equals: 2 * 140 - 20
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testRender [

	| canvas |
	canvas := presenter canvas.
	canvas add: RSEllipse new.
	canvas add: RSLabel new.
	self assert: canvas shapes notEmpty.

	presenter render.
	self assert: canvas shapes notEmpty
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testRenderStepLinesOn [ 
    | canvas expectedLineCount |
    presenter stepTitles: #( 'One' 'Two' 'Three' 'Four' ).
    presenter visibleStepCount: 4.
    presenter activeIndex: 3.
    canvas := presenter canvas.
    canvas shapes do: [ :s | canvas removeShape: s ].

    presenter renderStepLinesOn: canvas.

    expectedLineCount := presenter visibleStepIndexes size - 1.
    self assert: (canvas shapes count: [ :s | s isKindOf: RSLine ]) equals: expectedLineCount.
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testRenderStepsOn [

	| canvas |
	presenter stepTitles: #( 'One' 'Two' 'Three' ).
	presenter activeIndex: 2.
	presenter visibleStepCount: 5.
	canvas := presenter canvas.
	canvas addAllShapes: #(  ).

	presenter renderStepsOn: canvas.
	self assert: canvas shapes notEmpty.
	self assert: (canvas shapes anySatisfy: [ :s |
				 (s isKindOf: RSEllipse) and: [
					 s radius > (presenter instVarNamed: 'radius') ] ]).
	self assert: (canvas shapes anySatisfy: [ :s | s isKindOf: RSLabel ])
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testStepTitleForIndex [

	presenter stepTitles: #( 'Intro' 'Details' 'Finish' ).
	self assert: (presenter stepTitleForIndex: 1) equals: 'Intro'.
	self assert: (presenter stepTitleForIndex: 2) equals: 'Details'.
	self assert: (presenter stepTitleForIndex: 3) equals: 'Finish'.
	self assert: (presenter stepTitleForIndex: 4) equals: ''
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testStepTitles [
	| newTitles |
	newTitles := #( 'Start' 'Details' 'Finish' ).
	presenter stepTitles: newTitles.
	self assert: (presenter instVarNamed: 'stepTitles') equals: newTitles.
]

{ #category : 'tests' }
WizardStepHeaderPresenterTest >> testVisibleStepIndexes [

	presenter stepTitles: #( 'A' 'B' 'C' 'D' 'E' 'F' 'G' ).

	presenter visibleStepCount: 7.
	presenter activeIndex: 4.
	self
		assert: presenter visibleStepIndexes
		equals: #( 1 2 3 4 5 6 7 ) asOrderedCollection.

	presenter visibleStepCount: 5.
	presenter activeIndex: 4.
	self
		assert: presenter visibleStepIndexes
		equals: #( 2 3 4 5 6 ) asOrderedCollection.

	presenter visibleStepCount: 3.
	presenter activeIndex: 1.
	self
		assert: presenter visibleStepIndexes
		equals: #( 1 2 3 ) asOrderedCollection.

	presenter visibleStepCount: 3.
	presenter activeIndex: 7.
	self
		assert: presenter visibleStepIndexes
		equals: #( 5 6 7 ) asOrderedCollection
]
