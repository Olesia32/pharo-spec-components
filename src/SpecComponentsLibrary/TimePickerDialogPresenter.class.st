Class {
	#name : 'TimePickerDialogPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenre',
		'canvas',
		'center',
		'radius',
		'selectedHour',
		'selectedMinute',
		'hourCircles',
		'selectionDot',
		'selectionLine',
		'backgroundCircle',
		'hourLabel',
		'minutesLabel',
		'isHourMode',
		'okButton',
		'isPm',
		'amButton',
		'pmButton',
		'cancelButton',
		'onOkAction',
		'onCancelAction',
		'onChanged'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'adding' }
TimePickerDialogPresenter >> addSelectionMarker [

	| tmp1 tmp2 |
	tmp1 := RSEllipse new.
	tmp1 radius: 5.
	selectionDot := tmp1 color: Color purple.
	canvas add: selectionDot.
	tmp2 := RSLine new.
	tmp2 color: Color purple.
	selectionLine := tmp2 width: 2.
	canvas add: selectionLine
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> buildClockFace [ 
	| pointFor |
	pointFor := [ :c :r :angle |
		| rad |
		rad := angle degreesToRadians.
		c + (r * rad cos @ (r * rad sin)) ].

	1 to: 12 do: [ :i |
		| angle pos circle label |
		angle := i * 30 - 90.
		pos := pointFor value: center value: radius - 20 value: angle.
		circle := RSEllipse new radius: 20; color: Color veryLightGray.
		circle translateTo: pos.
		canvas add: circle.
		hourCircles at: i put: circle.

		label := RSLabel new.
		label fontSize: 12; translateTo: pos.
		canvas add: label.]
	
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> connectPresenters [

	hourLabel onClick: [ self isHourMode: true ].
	minutesLabel onClick: [ self isHourMode: false ]
]

{ #category : 'layout' }
TimePickerDialogPresenter >> defaultLayout [

	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	tmp3 := SpBoxLayout newTopToBottom.
	tmp3 spacing: 10.
	tmp1 := tmp3 hAlignCenter.
	tmp5 := SpBoxLayout newTopToBottom
		        add: amButton;
		        add: pmButton.
	tmp2 := SpBoxLayout newLeftToRight.
	tmp2
		spacing: 5;
		vAlignCenter;
		add: hourLabel withConstraints: [ :arg1 | arg1 height: 50 ].
	tmp4 := LabelPresenter new.
	tmp4 fontSize: 16.
	tmp2
		add: (tmp4 text: ':') expand: false;
		add: minutesLabel withConstraints: [ :arg2 | arg2 height: 50 ];
		add: tmp5.
	tmp1
		add: tmp2 expand: true;
		add: roassalPresenre withConstraints: [ :arg3 |
				arg3
					width: 210;
					height: 210 ].
	^ tmp1 yourself
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> drawBackgroundCircle [

	| tmp1 |
	tmp1 := RSEllipse new.
	tmp1 radius: radius.
	backgroundCircle := tmp1 color: Color veryLightGray.
	backgroundCircle translateTo: center.
	canvas add: backgroundCircle
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> initializeDialogWindow: arg1 [

	arg1
		title: 'Оберіть час';
		initialExtent: 300 @ 350;
		layout: self defaultLayout;
		addButton: 'Скасувати' do: [
				onCancelAction ifNotNil: [ onCancelAction value ].
				arg1 close ];
		addButton: 'Підтвердити' do: [
				| tmp1 |
				onOkAction ifNotNil: [
							tmp1 := Dictionary new.
							tmp1
								at: #hour put: selectedHour;
					at: #minute put: selectedMinute;
					at: #pm put: isPm.
							onOkAction value: tmp1 yourself ].
				arg1
					beOk;
					close ]
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> initializePresenters [

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
	amButton := ButtonPresenter new
		            label: 'AM';
		            onClick: [ self switchToAm ].
	pmButton := ButtonPresenter new
		            label: 'PM';
		            onClick: [ self switchToPm ].
	isPm := false.
	self isHourMode: true.
	selectedHour := 1.
	self
		isPm: false;
		drawBackgroundCircle;
		buildClockFace;
		updateClockLabels;
		addSelectionMarker;
		updateSelectionMarker
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> initializeWindow: arg1 [

	arg1
		title: 'Оберіть колір';
		initialExtent: 450 @ 500
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> isHourMode: aBool [ 
	isHourMode := aBool.
	self updateSelectionHighlight.
	self updateClockLabels.
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> isPm: aBool [ 
	isPm := aBool.
	self updateAmPmButtons.
	self updateClockLabels.
]

{ #category : 'showing' }
TimePickerDialogPresenter >> onCancel: arg1 [

	onCancelAction := arg1
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> onChanged: aBlook [
onChanged := aBlook 
]

{ #category : 'showing' }
TimePickerDialogPresenter >> onOk: arg1 [

	onOkAction := arg1
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> selectedHour [

	^ selectedHour
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedHour: arg1 [

	selectedHour := arg1.
	hourLabel label: arg1 asString
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedMinute [

	^ selectedMinute
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedMinute: arg1 [

	selectedMinute := arg1.
	minutesLabel label: selectedMinute asString.
	self updateSelectionMarker
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> switchToAm [
	self isPm: false
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> switchToPm [
	self isPm: true
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateAmPmButtons [
	amButton backgroundColor: (isPm ifTrue: ['#veryLightGray'] ifFalse: ['#e5cfee']).
	pmButton backgroundColor: (isPm ifTrue: ['#e5cfee'] ifFalse: ['#veryLightGray']).
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateClockLabels [

	| startHour windowMorph bounds|
	startHour := isHourMode
		             ifTrue: [
				             isPm
					             ifTrue: [ 12 ]
					             ifFalse: [ 0 ] ]
		             ifFalse: [ 0 ].

	hourCircles keysAndValuesDo: [ :i :circle |
			| value label newLabel pos |
			value := isHourMode
				         ifTrue: [
						         i = 12
							         ifTrue: [ startHour ]
							         ifFalse: [ startHour + i ] ]
				         ifFalse: [
						         i = 12
							         ifTrue: [ 0 ]
							         ifFalse: [ i * 5 ] ].

			pos := circle position.
			label := canvas shapes
				         detect: [ :s |
				         (s isKindOf: RSLabel) and: [ s position = pos ] ]
				         ifNone: [ nil ].
			label ifNotNil: [ canvas removeShape: label ].

			newLabel := RSLabel new
				            text: value asString;
				            fontSize: 12;
				            translateTo: pos.
			canvas add: newLabel.

			circle
				when: RSMouseClick
				do: [
						isHourMode
							ifTrue: [
									self selectedHour: value.
									self isHourMode: false ]
							ifFalse: [ self selectedMinute: value ] ]
				for: self ].
		
	windowMorph := self owner ifNotNil: [ :o | o adapter widget ].
	windowMorph ifNotNil: [
	bounds := windowMorph bounds.
	windowMorph bounds: (bounds insetBy: 1).
	windowMorph bounds: bounds
].
			self owner ifNotNil: [ self owner ]
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateSelectionHighlight [

	hourLabel backgroundColor: (isHourMode
			 ifTrue: [ '#e5cfee' ]
			 ifFalse: [ '#veryLightGray' ]).
	minutesLabel backgroundColor: (isHourMode
			 ifTrue: [ '#veryLightGray' ]
			 ifFalse: [ '#e5cfee' ]).
	isHourMode ifTrue: [ amButton mainPresenter enabled: true. pmButton mainPresenter enabled: true]
	ifFalse: [ amButton mainPresenter enabled: false. pmButton mainPresenter enabled: false ]
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateSelectionMarker [

	| tmp1 tmp2 tmp3 tmp4 windowMorph bounds|
	selectedHour isNil ifTrue: [ ^ self ].
	nil.
	tmp1 := [ :arg1 :arg2 :arg3 |
		        | tmp5 |
		        tmp5 := arg3 degreesToRadians.
		        arg1 + (arg2 * tmp5 cos @ (arg2 * tmp5 sin)) ].
	tmp2 := tmp1
		        value: center
		        value: radius - 20
		        value: selectedHour * 30 - 90.
	selectionDot translateTo: center.
	selectionLine ifNotNil: [ canvas removeShape: selectionLine ].
	tmp4 := RSLine new.
	tmp4
		color: Color purple;
		width: 2;
		from: center.
	selectionLine := tmp4 to: tmp2.
	canvas add: selectionLine.
	hourCircles keysAndValuesDo: [ :arg4 :arg5 |
			arg5 color: (arg4 = selectedHour
					 ifTrue: [ Color purple ]
					 ifFalse: [ Color veryLightGray ]) ].
	windowMorph := self owner ifNotNil: [ :o | o adapter widget ].
	windowMorph ifNotNil: [
	bounds := windowMorph bounds.
	windowMorph bounds: (bounds insetBy: 1).
	windowMorph bounds: bounds
].
			self owner ifNotNil: [ self owner ]
]
