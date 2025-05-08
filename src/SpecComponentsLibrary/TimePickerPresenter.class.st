Class {
	#name : 'TimePickerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'openButton',
		'selectedHour',
		'selectedMinute',
		'roassalPresenre',
		'canvas',
		'center',
		'radius',
		'hourCircles',
		'selectionDot',
		'selectionLine',
		'backgroundCircle',
		'hourLabel',
		'minutesLabel',
		'isHourMode',
		'okButton',
		'cancelButton',
		'onOkAction',
		'onCancelAction',
		'timeFieldPresenter'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'adding' }
TimePickerPresenter >> addSelectionMarker [ 
	selectionDot := RSEllipse new radius: 5; color: Color purple.
	canvas add: selectionDot.
	selectionLine := RSLine new color: Color purple; width: 2.
	canvas add: selectionLine.
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> buildClockFace [ 
	| circlePoint innerRadius |
	circlePoint := [ :center :radius :angleDeg |
		| radians |
		radians := angleDeg degreesToRadians.
		center + (radius * radians cos @ (radius * radians sin)) ].
	innerRadius := radius - 20.
	1 to: 12 do: [ :i |
		| angle pos circle label |
		angle := i * 30 - 90.
		pos := circlePoint value: center value: innerRadius value: angle.
		circle := RSEllipse new radius: 20; color: Color veryLightGray.
		circle translateTo: pos.
		circle when: RSMouseClick do: [ self selectHour: i ] for: self.
		canvas add: circle.
		label := RSLabel new text: i asString.
		label fontSize: 12.
		label translateTo: pos.
		canvas add: label.
		hourCircles at: i put: circle ].
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> buildClockLayout [ 
	| tmp1 tmp2|
	tmp1 := SpBoxLayout newTopToBottom spacing: 10; hAlignCenter.
	tmp2 := SpBoxLayout newLeftToRight spacing: 5; vAlignCenter.
	tmp2
		add: hourLabel withConstraints: [ :c | c height: 50 ];
		add: (LabelPresenter new fontSize: 16; text: ':') expand: false;
		add: minutesLabel withConstraints: [ :c | c height: 50 ].
	tmp1 add: tmp2 expand: true.
	tmp1 add: roassalPresenre withConstraints: [ :c |
		c width: 210; height: 210 ].
	^ tmp1 yourself
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> buildFooterLayout [ 
	^ SpBoxLayout newLeftToRight
		spacing: 10;
		hAlignCenter;
		add: okButton;
		add: cancelButton;
		yourself
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> buildHeaderLayout [ 
	| tmp |
	tmp := SpBoxLayout newLeftToRight spacing: 5; vAlignCenter.
	tmp
		add: hourLabel withConstraints: [ :c | c height: 50 ];
		add: (LabelPresenter new fontSize: 16; text: ':') expand: false;
		add: minutesLabel withConstraints: [ :c | c height: 50 ].
	^ tmp
]

{ #category : 'initialization' }
TimePickerPresenter >> connectPresenters [

	hourLabel onClick: [ self isHourMode: true ].
	minutesLabel onClick: [ self isHourMode: false ]
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> defaultDialogLayout [

	| l |
	l := SpBoxLayout newTopToBottom
		          spacing: 10;
		          hAlignCenter.
	l add: self buildHeaderLayout.
	l add: roassalPresenre withConstraints: [ :c |
			c
				width: 210;
				height: 210 ].
	^ l
]

{ #category : 'layout' }
TimePickerPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: timeFieldPresenter;
		  add: openButton withConstraints: [:c | c width: 50];
		  yourself
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> drawBackgroundCircle [ 
	backgroundCircle := RSEllipse new radius: radius; color: Color veryLightGray; borderColor: Color lightGray; borderWidth: 1.
	backgroundCircle translateTo: center.
	canvas add: backgroundCircle.
]

{ #category : 'initialization' }
TimePickerPresenter >> initializeClockCanvas [ 
	roassalPresenre := self newRoassal.
	canvas := roassalPresenre canvas.
	center := 0 @ 0.
	radius := 100.
	hourCircles := Dictionary new.
	hourLabel := ButtonPresenter new.
	hourLabel fontSize: 16; label: '12'; bold.
	minutesLabel := ButtonPresenter new.
	minutesLabel fontSize: 16; label: '00'; bold.
	self isHourMode: true.
	self drawBackgroundCircle.
	self buildClockFace.
	self addSelectionMarker.
	self updateSelectionMarker.
]

{ #category : 'initialization' }
TimePickerPresenter >> initializeDialogWindow: aDialogPresenter [

	aDialogPresenter centered.
	aDialogPresenter layout: self defaultDialogLayout.
	aDialogPresenter
		addButton: 'Скасувати' do: [ aDialogPresenter close ];
		addButton: 'OK' do: [
				aDialogPresenter beOk.
				aDialogPresenter close ]
]

{ #category : 'initialization' }
TimePickerPresenter >> initializePresenters [

	super initializePresenters.

	timeFieldPresenter := TextInputPresenter new.
	timeFieldPresenter text: '12:00'.
	timeFieldPresenter mainPresenter editable: false.

	openButton := ButtonPresenter new.
	openButton mainPresenter icon: (self iconNamed: 'clock').
	openButton onClick: [ self openDialog ].

	selectedHour := 12.
	selectedMinute := 0.
	self initializeClockCanvas.

	okButton := ButtonPresenter new.
	okButton label: 'OK'.

	cancelButton := ButtonPresenter new.
	cancelButton label: 'Скасувати'
]

{ #category : 'accessing' }
TimePickerPresenter >> isHourMode: aBoolean [ 
	isHourMode := aBoolean.
	isHourMode
		ifTrue: [ hourLabel backgroundColor: '#e5cfee'.  minutesLabel backgroundColor: '#veryLightGray']
		ifFalse: [ minutesLabel backgroundColor: '#e5cfee'. hourLabel backgroundColor: '#veryLightGray'.]
]

{ #category : 'showing' }
TimePickerPresenter >> onCancel: aBlock [ 
 onCancelAction := aBlock 
]

{ #category : 'showing' }
TimePickerPresenter >> onOk: aBlock [ 
 onOkAction := aBlock 
]

{ #category : 'layout' }
TimePickerPresenter >> openDialog [

	| dialog |
	dialog := self openModal.
	dialog title: 'Оберіть час'.
	dialog whenClosedDo: [
			dialog isOk
				ifTrue: [
						onOkAction ifNotNil: [
								onOkAction value: {
										(#hour -> selectedHour).
										(#minute -> selectedMinute) } ] ]
				ifFalse: [ onCancelAction ifNotNil: [ onCancelAction value ] ] ]
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> selectHour: arg1 [ 
	selectedHour := arg1.
	isHourMode
		ifTrue: [ hourLabel label: selectedHour asString. self isHourMode: false ]
		ifFalse: [ selectedMinute := arg1 * 5. minutesLabel label: (selectedMinute printPaddedWith: '0' to: 2 )].
	self updateSelectionMarker
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> updateSelectionMarker [ 
	| circlePoint pos |
	selectedHour isNil ifTrue: [ ^ self ].
	circlePoint := [ :center :radius :angleDeg |
		| radians |
		radians := angleDeg degreesToRadians.
		center + (radius * radians cos @ (radius * radians sin)) ].
	pos := circlePoint value: center value: radius - 20 value: selectedHour * 30 - 90.
	selectionDot translateTo: center.
	selectionLine ifNotNil: [ canvas removeShape: selectionLine ].
	selectionLine := RSLine new color: Color purple; width: 2; from: center; to: pos.
	canvas add: selectionLine.
	hourCircles keysAndValuesDo: [ :key :circle |
		circle color: (key = selectedHour ifTrue: [ Color purple ] ifFalse: [ Color veryLightGray ]) ].
]
