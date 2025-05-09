Class {
	#name : 'TimePickerDialogPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenre',
		'canvas',
		'center',
		'radius',
		'selectedHour',
		'startHour',
		'mainColor',
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
		'onChanged',
		'accentColor'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'adding' }
TimePickerDialogPresenter >> addSelectionMarker [

	| tmp1 tmp2 |
	tmp1 := RSEllipse new.
	tmp1 radius: 5.
	selectionDot := tmp1 color: mainColor.
	canvas add: selectionDot.
	tmp2 := RSLine new.
	tmp2 color: mainColor.
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
		canvas add: label ]
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> connectPresenters [

	hourLabel onClick: [ self isHourMode: true ].
	minutesLabel onClick: [ self isHourMode: false ].
	amButton onClick: [ self switchToAm ].
	pmButton onClick: [ self switchToPm ].
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
		add: hourLabel withConstraints: [ :arg1 | arg1 height: 50; width: 70 ].
	tmp4 := LabelPresenter new.
	tmp4 fontSize: 16.
	tmp2
		add: (tmp4 text: ':') expand: false;
		add: minutesLabel withConstraints: [ :arg2 | arg2 height: 50; width: 70 ];
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
	startHour := 0.
	selectedMinute := 0.
	mainColor := Color purple.
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
		            label: 'AM'.
	pmButton := ButtonPresenter new
		            label: 'PM'.
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
		title: 'Оберіть час';
		initialExtent: 450 @ 500
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> isHourMode: aBool [

	isHourMode := aBool.
	self updateSelectionHighlight.
	self updateClockLabels.
	self updateSelectionMarker 
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> isPm: aBool [

	isPm := aBool.
	selectionLine ifNotNil: [
			canvas removeShape: selectionLine.
			selectionLine := nil ].
	self updateClockLabels
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> mainColor: aColor [

	mainColor := aColor.
	selectionDot ifNotNil: [ selectionDot color: aColor ].
	self updateSelectionMarker.
	self updateAmPmButtons.
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

	selectedHour := (arg1 max: 0) min: 23.
	hourLabel label: (arg1 < 10
			 ifTrue: [ '0' , arg1 asString ]
			 ifFalse: [ arg1 asString ]).
	selectedHour > 12 ifTrue: [ self switchToPm ].
	self updateSelectionMarker
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedMinute [

	^ selectedMinute
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedMinute: arg1 [

	selectedMinute := (arg1 max: 0) min: 59.
	minutesLabel label: (arg1 < 10
			 ifTrue: [ '0' , arg1 asString ]
			 ifFalse: [ arg1 asString ]).
	self updateSelectionMarker
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> switchToAm [

	self isPm: false.
	startHour := 0.
	self updateAmPmButtons.
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> switchToPm [

	self isPm: true.
	startHour := 12.
	self updateAmPmButtons 
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateAmPmButtons [

	amButton mainPresenter color: (isPm
			 ifTrue: [ Color veryLightGray ]
			 ifFalse: [ mainColor muchLighter ]).
	pmButton mainPresenter color: (isPm
			 ifTrue: [ mainColor muchLighter ]
			 ifFalse: [ Color veryLightGray ])
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateClockLabels [

	| startHour windowMorph bounds pointFor |
	startHour := isHourMode
		             ifTrue: [
				             isPm
					             ifTrue: [ 12 ]
					             ifFalse: [ 0 ] ]
		             ifFalse: [ 0 ].

	pointFor := [ :c :r :angle |
		            | rad |
		            rad := angle degreesToRadians.
		            c + (r * rad cos @ (r * rad sin)) ].

	"Очистити старі кола та підписи"
	hourCircles valuesDo: [ :c | canvas removeShape: c ].
	(canvas shapes select: [ :s | s isKindOf: RSLabel ]) do: [ :l |
		canvas removeShape: l ].


	hourCircles := Dictionary new.
	1 to: 12 do: [ :i |
			| value angle pos circle label |
			value := isHourMode
				         ifTrue: [
						         i = 12
							         ifTrue: [ startHour ]
							         ifFalse: [ startHour + i ] ]
				         ifFalse: [
						         i = 12
							         ifTrue: [ 0 ]
							         ifFalse: [ i * 5 ] ].

			angle := i * 30 - 90.
			pos := pointFor value: center value: radius - 20 value: angle.

			circle := RSEllipse new
				          radius: 20;
				          color: Color veryLightGray.
			circle translateTo: pos.
			canvas add: circle.
			hourCircles at: i put: circle.

			label := RSLabel new
				         text: value asString;
				         fontSize: 12;
				         translateTo: pos.
			canvas add: label.

			circle
				when: RSMouseClick
				do: [
						isHourMode
							ifTrue: [
									self selectedHour: value.]
							ifFalse: [
									self selectedMinute: value. ] ]
				for: self ].

	windowMorph := self owner ifNotNil: [ :o | o adapter widget ].
	windowMorph ifNotNil: [
			bounds := windowMorph bounds.
			windowMorph bounds: (bounds insetBy: 1).
			windowMorph bounds: bounds ].
	self owner ifNotNil: [ self owner ]
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateSelectionHighlight [

	hourLabel mainPresenter color: (isHourMode
			 ifTrue: [ mainColor muchLighter ]
			 ifFalse: [ Color veryLightGray ]).
	minutesLabel mainPresenter color: (isHourMode
			 ifTrue: [ Color veryLightGray ]
			 ifFalse: [ mainColor muchLighter ]).
	isHourMode
		ifTrue: [
				amButton mainPresenter enabled: true.
				pmButton mainPresenter enabled: true ]
		ifFalse: [
				amButton mainPresenter enabled: false.
				pmButton mainPresenter enabled: false ]
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateSelectionMarker [

	| tmp1 tmp2 tmp4 windowMorph bounds |
	selectedHour isNil ifTrue: [ ^ self ].
	tmp1 := [ :arg1 :arg2 :arg3 |
		        | tmp5 |
		        tmp5 := arg3 degreesToRadians.
		        arg1 + (arg2 * tmp5 cos @ (arg2 * tmp5 sin)) ].
	tmp2 := tmp1 value: center value: radius - 40 value: (isHourMode
			         ifTrue: [ selectedHour - startHour \\ 12 * 30 - 90 ]
			         ifFalse: [ selectedMinute * 6 - 90 ]).

	selectionDot translateTo: center.
	selectionLine ifNotNil: [ canvas removeShape: selectionLine ].
	tmp4 := RSLine new.
	tmp4
		color: mainColor ;
		width: 2;
		from: center.
	selectionLine := tmp4 to: tmp2.
	canvas add: selectionLine.
	hourCircles keysAndValuesDo: [ :i :circle |
			| labelHour |
			labelHour := isHourMode
				             ifTrue: [
						             i = 12
							             ifTrue: [ startHour ]
							             ifFalse: [ startHour + i ] ]
				             ifFalse: [
						             i = 12
							             ifTrue: [ 0 ]
							             ifFalse: [ i * 5 ] ].

			circle color: (isHourMode
					 ifTrue: [
							 selectedHour = labelHour
								 ifTrue: [ mainColor ]
								 ifFalse: [ Color veryLightGray ] ]
					 ifFalse: [
							 selectedMinute = labelHour
								 ifTrue: [ mainColor ]
								 ifFalse: [ Color veryLightGray ] ]) ].

	windowMorph := self owner ifNotNil: [ :o | o adapter widget ].
	windowMorph ifNotNil: [
			bounds := windowMorph bounds.
			windowMorph bounds: (bounds insetBy: 1).
			windowMorph bounds: bounds ].
	self owner ifNotNil: [ self owner ]
]
