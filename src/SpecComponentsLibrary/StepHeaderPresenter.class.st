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
		'labelFontSize',
		'titleFontSize',
		'labelColor'
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
StepHeaderPresenter >> canvas [ 
  ^ roassalPresenter canvas
]

{ #category : 'layout' }
StepHeaderPresenter >> defaultLayout [ 
    ^ SpBoxLayout newTopToBottom
        spacing: 0;
        add: roassalPresenter;
        yourself
]

{ #category : 'initialization' }
StepHeaderPresenter >> initializePresenters [ 
    radius := 20.
    stepSpacing := 120.
    activeIndex := 1.
    activeColor := Color r: 0.95 g: 0.4 b: 0.4.
    defaultColor := Color white.
    borderColor := Color lightGray.
    labelFontSize := 12.
    titleFontSize := 10.
    labelColor := Color black.
    stepTitles := #('Step 1' 'Step 2' 'Step 3').

    roassalPresenter := self newRoassal.
    roassalPresenter canvas background: Color transparent.
    self render.
]

{ #category : 'accessing' }
StepHeaderPresenter >> labelColor: aColor [ 
    labelColor := aColor.
    self render.
]

{ #category : 'accessing' }
StepHeaderPresenter >> labelFontSize: aNumber [ 
    labelFontSize := aNumber.
    self render.
]

{ #category : 'accessing' }
StepHeaderPresenter >> radius: aNumber [ 
    radius := aNumber.
    self render.
]

{ #category : 'rendering' }
StepHeaderPresenter >> render [
    | view startX startY |
    view := roassalPresenter canvas.
    view shapes do: [ :each | view removeShape: each ].

    startX := 0. "відступ зліва"
    startY := 0. "висота лінії кнопок"

    (1 to: stepTitles size) do: [ :i |
        | xPos circle label title stepColor outerCircle |

        xPos := startX + ((i - 1) * stepSpacing).
        stepColor := (i <= activeIndex) ifTrue: [ activeColor ] ifFalse: [ defaultColor ].

        (i = activeIndex) ifTrue: [
            outerCircle := RSEllipse new.
            outerCircle radius: radius + 4.
            outerCircle color: Color transparent.
            outerCircle borderColor: activeColor darker.
            outerCircle borderWidth: 2.
            outerCircle position: xPos @ startY.
            view add: outerCircle
        ].

        circle := RSEllipse new.
        circle radius: radius.
        circle color: stepColor.
        circle borderColor: (i = activeIndex ifTrue: [ activeColor darker ] ifFalse: [ borderColor ]).
        circle borderWidth: 1.
        circle position: xPos @ startY.

        label := RSLabel new.
        label text: i asString.
        label color: (i <= activeIndex ifTrue: [ Color white ] ifFalse: [ labelColor ]).
        label fontSize: labelFontSize.
        label position: xPos @ startY.

        title := RSLabel new.
        title text: (stepTitles at: i).
        title color: Color black.
        title fontSize: titleFontSize.
        title position: xPos @ (startY + 35).

        view addAll: { circle. label. title }.
    ].

    1 to: (stepTitles size - 1) do: [ :i |
        | start end lineColor line |
        start := startX + ((i - 1) * stepSpacing) + radius.
        end := startX + (i * stepSpacing) - radius.

        lineColor := (i < activeIndex ifTrue: [ activeColor ] ifFalse: [ borderColor ]).

        line := RSLine newFrom: (start @ startY) to: (end @ startY).
        line color: lineColor.
        line width: 2.

        view add: line.
    ].

]

{ #category : 'accessing' }
StepHeaderPresenter >> stepTitles: aCollection [ 
    stepTitles := aCollection.
    self render.
]

{ #category : 'accessing' }
StepHeaderPresenter >> titleFontSize: aNumber [ 
    titleFontSize := aNumber.
    self render.
]
