Class {
	#name : 'StepHeaderPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter',
		'view',
		'radius',
		'stepSpacing',
		'activeIndex',
		'stepTitles',
		'activeColor',
		'defaultColor',
		'borderColor'
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
 ^ view 
]

{ #category : 'layout' }
StepHeaderPresenter >> defaultLayout [
    ^ SpBoxLayout newTopToBottom
        add: roassalPresenter;
        yourself
]

{ #category : 'initialization' }
StepHeaderPresenter >> initializePresenters [ 
    radius := 20.
    stepSpacing := 120.
    activeIndex := 1.
    activeColor := Color r: 0.95 g: 0.4 b: 0.4.
    defaultColor := Color veryLightGray.
    borderColor := Color lightGray.
    stepTitles := #('Step 1' 'Step 2' 'Step 3').
    roassalPresenter := self newRoassal.
    view := RSCanvas new.
    self render.


]

{ #category : 'rendering' }
StepHeaderPresenter >> render [ 
    view shapes do: [ :each | view removeShape: each ].

    (1 to: stepTitles size) do: [ :i |
        | xPos circle label title stepColor |

        xPos := 100 + (i - 1 * stepSpacing).
        stepColor := (i = activeIndex) ifTrue: [ activeColor ] ifFalse: [ defaultColor ].

        circle := RSEllipse new.
        circle radius: radius.
        circle color: stepColor.
        circle borderColor: (i = activeIndex ifTrue: [ activeColor darker ] ifFalse: [ borderColor ]).
        circle borderWidth: (i = activeIndex ifTrue: [ 2 ] ifFalse: [ 1 ]).
        circle position: xPos@100.

        label := RSLabel new.
        label text: i asString.
        label color: (i = activeIndex ifTrue: [ Color white ] ifFalse: [ Color black ]).
        label fontSize: 12.
        label position: xPos@100.

        title := RSLabel new.
        title text: (stepTitles at: i).
        title color: Color black.
        title fontSize: 10.
        title position: xPos@135.

        view addAll: { circle. label. title }.
    ].

    1 to: (stepTitles size - 1) do: [ :i |
        | start end lineColor line |
        start := 100 + (i - 1 * stepSpacing) + radius.
        end := 100 + (i * stepSpacing) - radius.

        lineColor := (i < activeIndex ifTrue: [ activeColor ] ifFalse: [ defaultColor ]).

        line := RSLine newFrom: (start@100) to: (end@100).
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
