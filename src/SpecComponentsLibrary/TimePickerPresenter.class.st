Class {
	#name : 'TimePickerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenre',
		'canvas',
		'center',
		'radius',
		'selectedHour',
		'hourCircles',
		'selectionDot',
		'selectionLine',
		'backgroundCircle',
		'hourLabel',
		'minutesLabel',
		'isHourMode',
		'okButton',
		'cancelButton'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'adding' }
TimePickerPresenter >> addSelectionMarker [

	selectionDot := RSEllipse new
		                radius: 5;
		                color: Color purple.
	canvas add: selectionDot.

	selectionLine := RSLine new
		                 color: Color purple;
		                 width: 2.
	canvas add: selectionLine.

]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> buildClockFace [

	| circlePoint innerRadius |
circlePoint := [ :center :radius :angleDeg |
    | radians |
    radians := angleDeg degreesToRadians.
    center + (radius * radians cos @ (radius * radians sin))
].

innerRadius := radius - 20. "20 — це радіус маленького круга"

1 to: 12 do: [ :i |
    | angle pos circle label |

    angle := i * 30 - 90.
    pos := circlePoint value: center value: innerRadius value: angle.

    circle := RSEllipse new
        radius: 20;
        color: Color veryLightGray.

    circle translateTo: pos.

    circle when: RSMouseClick do: [ self selectHour: i ] for: self.

    canvas add: circle.

    label := RSLabel new text: i asString.
    label fontSize: 12.
    label translateTo: pos.
    canvas add: label.

    hourCircles at: i put: circle
].

]

{ #category : 'initialization' }
TimePickerPresenter >> connectPresenters [

	hourLabel onClick: [ self isHourMode: true ].
	minutesLabel onClick: [ self isHourMode: false ]
]

{ #category : 'layout' }
TimePickerPresenter >> defaultLayout [

	| tmp1 tmp2|
	tmp1 := SpBoxLayout newTopToBottom
		        spacing: 10;
		        hAlignCenter.
	tmp2 := SpBoxLayout newLeftToRight.
	tmp2
		spacing: 5;
		vAlignCenter;
		add: hourLabel withConstraints: [ :c | c height: 50 ];
		add: (LabelPresenter new
				 fontSize: 16;
				 text: ':')
		expand: false;
		add: minutesLabel withConstraints: [ :c | c height: 50 ].
	tmp1 add: tmp2 expand: true.
	tmp1 add: roassalPresenre withConstraints: [ :c |
			c
				width: 210;
				height: 210 ].
	^ tmp1 yourself .
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> drawBackgroundCircle [

	| tmp1 |
	tmp1 := RSEllipse new.
	tmp1
		radius: radius;
		color: Color veryLightGray;
		borderColor: Color lightGray.
	backgroundCircle := tmp1 borderWidth: 1.
	backgroundCircle translateTo: center.
	canvas add: backgroundCircle
]

{ #category : 'initialization' }
TimePickerPresenter >> initializePresenters [

	super initializePresenters.
	roassalPresenre := self newRoassal.
	canvas := roassalPresenre canvas.
	center := 0 @ 0.
	radius := 100.
	hourCircles := Dictionary new.
	hourLabel := ButtonPresenter new.
	hourLabel
		fontSize: 16;
		label: '12';
		bold.
	minutesLabel := ButtonPresenter new.
	minutesLabel
		fontSize: 16;
		label: '00';
		bold.
	self isHourMode: true.
	selectedHour := 12.
	self drawBackgroundCircle.
	self buildClockFace.
	self addSelectionMarker.
	self updateSelectionMarker
]

{ #category : 'accessing' }
TimePickerPresenter >> isHourMode: aBoolean [

	isHourMode := aBoolean.
	isHourMode
		ifTrue: [ hourLabel backgroundColor: '#e5cfee'.  minutesLabel backgroundColor: '#veryLightGray']
		ifFalse: [ minutesLabel backgroundColor: '#e5cfee' . hourLabel backgroundColor: '#veryLightGray'.]
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> selectHour: arg1 [

	selectedHour := arg1.
	isHourMode
		ifTrue: [
				hourLabel label: selectedHour asString .
				self isHourMode: false ]
		ifFalse: [ minutesLabel label: selectedHour asString ].
	self updateSelectionMarker
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> updateSelectionMarker [

	| circlePoint pos line |
	selectedHour isNil ifTrue: [ ^ self ].

	circlePoint := [ :center :radius :angleDeg |
		               | radians |
		               radians := angleDeg degreesToRadians.
		               center
		               + (radius * radians cos @ (radius * radians sin)) ].

	pos := circlePoint
		       value: center
		       value: radius - 20
		       value: selectedHour * 30 - 90.
	selectionDot translateTo: center.

	selectionLine ifNotNil: [ canvas removeShape: selectionLine ].
	selectionLine := RSLine new
		                 color: Color purple;
		                 width: 2;
		                 from: center;
		                 to: pos.

	canvas add: selectionLine.

	"Пофарбувати відповідне коло\"
	hourCircles keysAndValuesDo: [ :key :circle |
			circle color: (key = selectedHour
					 ifTrue: [ Color purple ]
					 ifFalse: [ Color veryLightGray ]) ].
]
