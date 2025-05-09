Class {
	#name : 'StepHeaderPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter',
		'radius',
		'stepSpacing',
		'activeIndex',
		'stepTitles',
		'activeColor',
		'defaultColor',
		'borderColor',
		'titleFontSize',
		'titleColor',
		'labelFontSize',
		'visibleStepCount'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
StepHeaderPresenter >> activeColor: aColor [ 
    activeColor := aColor.
    self render.
]

{ #category : 'accessing' }
StepHeaderPresenter >> activeIndex: anInteger [ 
    activeIndex := anInteger.
    self render
]

{ #category : 'accessing' }
StepHeaderPresenter >> buildOuterCircleAt: x y: y color: aColor [ 
    ^ RSEllipse new
        radius: radius + 4;
        color: Color transparent;
        borderColor: aColor darker;
        borderWidth: 2;
        position: x @ y;
        yourself
]

{ #category : 'accessing' }
StepHeaderPresenter >> buildStepCircleAt: x y: y color: fillColor borderColor: strokeColor [ 
    ^ RSEllipse new
        radius: radius;
        color: fillColor;
        borderColor: strokeColor;
        borderWidth: 1;
        position: x @ y;
        yourself
]

{ #category : 'accessing' }
StepHeaderPresenter >> buildStepLabelAt: x y: y text: aString fontSize: aSize color: aColor [ 
    ^ RSLabel new
        text: aString;
        fontSize: aSize;
        color: aColor;
        position: x @ y;
        yourself
]

{ #category : 'accessing' }
StepHeaderPresenter >> buildStepTitleAt: x y: y text: aString [ 
    ^ RSLabel new
        text: aString;
        fontSize: titleFontSize;
        color: titleColor;
        position: x @ y;
        yourself
]

{ #category : 'accessing' }
StepHeaderPresenter >> canvas [ 
  ^ roassalPresenter canvas
]

{ #category : 'as yet unclassified' }
StepHeaderPresenter >> centerXOfStep: i plusRadius: aBool [ 
    | x |
    x := (i * stepSpacing).
    ^ aBool ifTrue: [ x + radius ] ifFalse: [ x - radius ].
]

{ #category : 'layout' }
StepHeaderPresenter >> defaultLayout [ 
    ^ SpBoxLayout newTopToBottom
        spacing: 0;
        add: roassalPresenter;
        yourself
]

{ #category : 'accessing' }
StepHeaderPresenter >> headerHeight [ 
  ^ ((radius + 4) * 2) + 20 + titleFontSize.

]

{ #category : 'initialization' }
StepHeaderPresenter >> initialize [

	super initialize.
	radius := 20.
	stepSpacing := 120.
	activeIndex := 1.
	activeColor := Color r: 0.95 g: 0.4 b: 0.4.
	defaultColor := Color white.
	borderColor := Color lightGray.
	labelFontSize := 12.
	titleFontSize := 10.
	titleColor := Color black.
	stepTitles := #( 'Step 1' 'Step 2' 'Step 3' ).
	visibleStepCount := 5.
	roassalPresenter := self newRoassal.
	roassalPresenter canvas background: Color transparent .
	self render
]

{ #category : 'accessing' }
StepHeaderPresenter >> labelFontSize: aNumber [ 
    labelFontSize := aNumber.
    self render.
]

{ #category : 'accessing' }
StepHeaderPresenter >> radius: aNumber [

	| totalWidth stepCount|
	radius := aNumber.
	stepSpacing := radius * 2 + 100.
	stepCount := visibleStepCount min: stepTitles size.
	totalWidth := (stepCount - 1) * stepSpacing.
	roassalPresenter canvas camera translateBy:
		(totalWidth / 2 @ (radius - 10)) negated.
	self render
]

{ #category : 'rendering' }
StepHeaderPresenter >> render [ 
    | view |
    view := roassalPresenter canvas.
    view shapes do: [ :each | view removeShape: each ].

    self renderStepsOn: view.
    self renderStepLinesOn: view.

]

{ #category : 'as yet unclassified' }
StepHeaderPresenter >> renderStepLinesOn: view [
	| indexes linesCount |
	indexes := self visibleStepIndexes.
	linesCount := indexes size.

	1 to: linesCount - 1 do: [ :i |
		| start end lineColor line globalLeftIndex |
		globalLeftIndex := indexes at: i.

		start := self centerXOfStep: i - 1 plusRadius: true.
		end := self centerXOfStep: i plusRadius: false.

		lineColor := globalLeftIndex < activeIndex
			ifTrue: [ activeColor ]
			ifFalse: [ borderColor ].

		line := RSLine newFrom: (start @ 0) to: (end @ 0).
		line color: lineColor.
		line width: 2.
		view add: line
	].

]

{ #category : 'rendering' }
StepHeaderPresenter >> renderStepsOn: view [ 
	| startX startY visibleIndexes i xPos stepColor circle label title outerCircle textSize textColor |
	startX := 0.
	startY := 0.
	visibleIndexes := self visibleStepIndexes.

	i := 0.
	visibleIndexes do: [ :idx |
		xPos := startX + (i * stepSpacing).
		i := i + 1.

		(idx = #ellipsis)
			ifTrue: [
				title := self buildStepTitleAt: xPos y: (startY + (radius + 4) + 15) text: '…'.
				view add: title
			]
			ifFalse: [
				stepColor := (idx <= activeIndex) ifTrue: [ activeColor ] ifFalse: [ defaultColor ].
				textSize := (radius * 0.6) rounded.
				textColor := (stepColor luminance < 0.7) ifTrue: [ Color white ] ifFalse: [ Color black ].

				(idx = activeIndex) ifTrue: [
					outerCircle := self buildOuterCircleAt: xPos y: startY color: activeColor.
					view add: outerCircle
				].

				circle := self buildStepCircleAt: xPos y: startY color: stepColor borderColor: (idx = activeIndex ifTrue: [ activeColor darker ] ifFalse: [ borderColor ]).
				label := self buildStepLabelAt: xPos y: startY text: idx asString fontSize: textSize color: textColor.
				title := self buildStepTitleAt: xPos y: (startY + (radius + 4) + 15) text: (self stepTitleForIndex: idx).

				view addAll: { circle. label. title }.
			].
	].
]

{ #category : 'initialization' }
StepHeaderPresenter >> stepTitleForIndex: index [ 
	index = #ellipsis ifTrue: [ ^ '…' ].
	^ stepTitles at: index ifAbsent: [ '' ]
]

{ #category : 'accessing' }
StepHeaderPresenter >> stepTitles: aCollection [ 
    stepTitles := aCollection.
    self render.
]

{ #category : 'accessing' }
StepHeaderPresenter >> titleColor: aColor [ 
    titleColor := aColor.
    self render.
]

{ #category : 'accessing' }
StepHeaderPresenter >> titleFontSize: aNumber [ 
    titleFontSize := aNumber.
    self render.
]

{ #category : 'accessing' }
StepHeaderPresenter >> visibleStepCount: aNumber [

	visibleStepCount := aNumber max: 1
]

{ #category : 'as yet unclassified' }
StepHeaderPresenter >> visibleStepIndexes [

	| totalSteps maxSteps halfWindow startIdx endIdx |
	totalSteps := stepTitles size.
	maxSteps := visibleStepCount .

	totalSteps <= maxSteps ifTrue: [
		^ (1 to: totalSteps) asOrderedCollection ].

	halfWindow := maxSteps // 2.
	startIdx := activeIndex - halfWindow max: 1.
	endIdx := startIdx + maxSteps - 1 min: totalSteps.
	startIdx := endIdx - maxSteps + 1 max: 1.

	^ (startIdx to: endIdx) asOrderedCollection
]
