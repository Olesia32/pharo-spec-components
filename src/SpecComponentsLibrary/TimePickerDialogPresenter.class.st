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
		'accentColor',
		'additionColor'
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

{ #category : 'accessing' }
TimePickerDialogPresenter >> additionColor: aColor [
   additionColor := aColor 
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
	additionColor := #e6e0f8.
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
	amButton := ButtonPresenter new label: 'AM'.
	pmButton := ButtonPresenter new label: 'PM'.
	isPm := false.
	self isHourMode: true.
	selectedHour := 1.
	self
		switchToAm ;
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
	self updateClockLabels.
	self updateSelectionMarker 
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
	self updateSelectionMarker 
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> switchToPm [

	self isPm: true.
	startHour := 12.
	self updateAmPmButtons.
	self updateSelectionMarker 
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateAmPmButtons [

	amButton backgroundColor: (isPm
			 ifTrue: [ '#veryLightGray' ]
			 ifFalse: [ additionColor ]).
	pmButton backgroundColor: (isPm
			 ifTrue: [ additionColor ]
			 ifFalse: [ '#veryLightGray' ])
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> updateClockLabels [

	| pointFor windowMorph bounds |
	pointFor := [ :c :r :angle |
		            | rad |
		            rad := angle degreesToRadians.
		            c + (r * rad cos @ (r * rad sin)) ].

	"Очистити старі кола та підписи"
	hourCircles valuesDo: [ :c | canvas removeShape: c ].
	(canvas shapes select: [ :s | s isKindOf: RSLabel ]) do: [ :l |
		canvas removeShape: l ].
	(canvas shapes select: [ :s | s isKindOf: RSLine ]) do: [ :l |
		canvas removeShape: l ].

	hourCircles := Dictionary new.

	isHourMode
		ifTrue: [ "=== ГОДИННИЙ РЕЖИМ ==="
				1 to: 12 do: [ :i |
						| value angle pos circle label |
						value := i = 12
							         ifTrue: [ startHour ]
							         ifFalse: [ startHour + i ].
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
							do: [ self selectedHour: value ]
							for: self ] ]
					
		ifFalse: [ "=== ХВИЛИННИЙ РЕЖИМ ==="
				0 to: 59 do: [ :i |
						| angle startPos endPos lineColor tickLength label pos invisibleHitbox |
						angle := i * 6 - 90.
						tickLength := i \\ 5 = 0
							              ifTrue: [ 10 ]
							              ifFalse: [ 5 ].
						startPos := pointFor
							            value: center
							            value: radius - 8
							            value: angle.
						endPos := pointFor
							          value: center
							          value: radius - 8 - tickLength
							          value: angle.

						lineColor := i \\ 5 = 0
							             ifTrue: [ Color black ]
							             ifFalse: [ Color gray ].
						canvas add: (RSLine new
								 from: startPos;
								 to: endPos;
								 color: lineColor;
								 width: 1).

						i \\ 5 = 0 ifTrue: [
								pos := pointFor value: center value: radius - 30 value: angle.
								label := RSLabel new
									         text: i printString;
									         fontSize: 10;
									         translateTo: pos.
								canvas add: label ].

						"Додати невидимий клікабельний об'єкт"
						invisibleHitbox := RSEllipse new
							                   radius: 5;
							                   color: Color transparent.
						invisibleHitbox translateTo: startPos.
						canvas add: invisibleHitbox.
						hourCircles at: i put: invisibleHitbox.
						invisibleHitbox
							when: RSMouseClick
							do: [ self selectedMinute: i ]
							for: self ] ].

	"Примусове оновлення вікна"
	windowMorph := self owner ifNotNil: [ :o | o adapter widget ].
	windowMorph ifNotNil: [
			bounds := windowMorph bounds.
			windowMorph bounds: (bounds insetBy: 1).
			windowMorph bounds: bounds ]
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateSelectionHighlight [

	hourLabel backgroundColor: (isHourMode
			 ifTrue: [ additionColor ]
			 ifFalse: [ '#veryLightGray' ]).
	minutesLabel backgroundColor: (isHourMode
			 ifTrue: [ '#veryLightGray' ]
			 ifFalse: [ additionColor ]).
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

	| computeTarget endPoint windowMorph bounds |

	selectedHour isNil ifTrue: [ ^ self ].

	computeTarget := [ :center :r :angleDeg |
		| rad |
		rad := angleDeg degreesToRadians.
		center + (r * rad cos @ (r * rad sin)) ].

	endPoint := computeTarget value: center value: (radius - 40) value: (
		isHourMode
			ifTrue: [ (selectedHour - startHour \\ 12) * 30 - 90 ]
			ifFalse: [ selectedMinute * 6 - 90 ]
	).

	(roassalPresenre canvas shapes includes: selectionLine) ifTrue: [
		canvas removeShape: selectionLine
	].
	selectionLine := RSLine new from: center; to: endPoint; color: mainColor; width: 2.
	canvas add: selectionLine.

	isHourMode ifTrue: [
		hourCircles keysAndValuesDo: [ :i :circle |
			| labelHour |
			labelHour := i = 12
				ifTrue: [ startHour ]
				ifFalse: [ startHour + i ].
			circle color: (
				selectedHour = labelHour
					ifTrue: [ mainColor ]
					ifFalse: [ Color veryLightGray ])
		] ].

	"Примусове оновлення"
	windowMorph := self owner ifNotNil: [ :o | o adapter widget ].
	windowMorph ifNotNil: [
		bounds := windowMorph bounds.
		windowMorph bounds: (bounds insetBy: 1).
		windowMorph bounds: bounds
	].
]
