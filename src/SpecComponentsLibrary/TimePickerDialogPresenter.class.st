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
		'cancelButton',
		'onOkAction',
		'onCancelAction'
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

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 |
	tmp1 := [ :arg1 :arg2 :arg3 |
		        | tmp9 |
		        tmp9 := arg3 degreesToRadians.
		        arg1 + (arg2 * tmp9 cos @ (arg2 * tmp9 sin)) ].
	tmp2 := radius - 20.
	1 to: 12 do: [ :tmp8 |
			tmp7 := nil.
			tmp3 := nil.
			tmp4 := nil.
			tmp5 := nil.
			tmp6 := nil.
			tmp3 := tmp8 * 30 - 90.
			tmp4 := tmp1 value: center value: tmp2 value: tmp3.
			tmp7 := RSEllipse new.
			tmp7 radius: 20.
			tmp5 := tmp7 color: Color veryLightGray.
			tmp5
				translateTo: tmp4;
				when: RSMouseClick do: [ isHourMode ifTrue: [ self selectedHour: tmp8. self isHourMode: false] ifFalse: [ self selectedMinute:tmp8 ]] for: self.
			canvas add: tmp5.
			tmp6 := RSLabel new text: tmp8 asString.
			tmp6
				fontSize: 12;
				translateTo: tmp4.
			canvas add: tmp6.
			hourCircles at: tmp8 put: tmp5 ].
	1
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> connectPresenters [

	hourLabel onClick: [ self isHourMode: true ].
	minutesLabel onClick: [ self isHourMode: false ]
]

{ #category : 'layout' }
TimePickerDialogPresenter >> defaultLayout [

	| tmp1 tmp2 tmp3 tmp4 |
	tmp3 := SpBoxLayout newTopToBottom.
	tmp3 spacing: 10.
	tmp1 := tmp3 hAlignCenter.
	tmp2 := SpBoxLayout newLeftToRight.
	tmp2
		spacing: 5;
		vAlignCenter;
		add: hourLabel withConstraints: [ :arg1 | arg1 height: 50 ].
	tmp4 := LabelPresenter new.
	tmp4 fontSize: 16.
	tmp2
		add: (tmp4 text: ':') expand: false;
		add: minutesLabel withConstraints: [ :arg2 | arg2 height: 50 ].
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
				onOkAction ifNotNil: [
							onOkAction value: (Dictionary new
    at: #hour put: selectedHour;
    at: #minute put: selectedMinute;
    yourself). ].
				arg1 beOk.
				arg1 close ]
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
	self isHourMode: true.
	selectedHour := 12.
	self
		drawBackgroundCircle;
		buildClockFace;
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
TimePickerDialogPresenter >> isHourMode: arg1 [

	isHourMode := arg1.
	isHourMode
		ifTrue: [
				hourLabel backgroundColor: '#e5cfee'.
				minutesLabel backgroundColor: '#veryLightGray' ]
		ifFalse: [
				minutesLabel backgroundColor: '#e5cfee'.
				hourLabel backgroundColor: '#veryLightGray' ]
]

{ #category : 'showing' }
TimePickerDialogPresenter >> onCancel: arg1 [

	onCancelAction := arg1 
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
TimePickerDialogPresenter >> updateSelectionMarker [

	| tmp1 tmp2 tmp3 tmp4 |
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
					 ifFalse: [ Color veryLightGray ]) ]
]
