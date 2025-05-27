"
I am a full-screen time selection dialog displayed as a circular clock interface.  
I allow selecting hours and minutes by clicking on visual elements, and support both 12-hour and 24-hour formats with AM/PM toggles.  
I am built using Roassal for visual rendering and include confirmation/cancel buttons for integration in modal workflows.  
I am primarily used as the view component inside `TimePickerPresenter`.

### Instance Variables

- _roassalPresenre_: a `SpRoassalPresenter` — Roassal visualization presenter that holds the clock diagram  
- _canvas_: a `RSCanvas` — the Roassal drawing canvas used for shapes  
- _center_: a `Point` — center of the circular clock  
- _radius_: an `Integer` — visual radius of the clock face  
- _selectedHour_: an `Integer` — currently selected hour (0–23)  
- _selectedMinute_: an `Integer` — currently selected minute (0–59)  
- _startHour_: an `Integer` — used to switch between AM (0) and PM (12)  
- _mainColor_: a `Color` — accent color used for highlighting  
- _additionColor_: a `Color` — secondary color used for selection highlights  
- _hourCircles_: a `Dictionary` — map of indexes to clickable hour or minute markers  
- _selectionDot_: a `RSEllipse` — small dot indicating current selection  
- _selectionLine_: a `RSLine` — line from center to current hour/minute  
- _backgroundCircle_: a `RSEllipse` — background clock circle  
- _hourLabel_, _minutesLabel_: `ButtonPresenter`s — toggles between hour and minute selection  
- _isHourMode_: a `Boolean` — whether currently selecting hour (`true`) or minute (`false`)  
- _isPm_: a `Boolean` — whether the selected time is PM  
- _amButton_, _pmButton_: `ButtonPresenter`s — toggles for AM and PM modes  
- _okButton_, _cancelButton_: `ButtonPresenter`s — confirmation and cancellation actions  
- _onOkAction_, _onCancelAction_: `BlockClosure`s — callbacks for OK or Cancel actions  
- _onChanged_: a `BlockClosure` — optional callback invoked on time changes

### Public API

- `TimePickerDialogPresenter>>#selectedHour`, `>>#selectedHour:` — gets or sets the selected hour  
- `TimePickerDialogPresenter>>#selectedMinute`, `>>#selectedMinute:` — gets or sets the selected minute  
- `TimePickerDialogPresenter>>#isHourMode:` — switches between hour/minute selection  
- `TimePickerDialogPresenter>>#isPm:` — sets PM state (and adjusts visual)  
- `TimePickerDialogPresenter>>#mainColor:`, `>>#additionColor:` — customize color scheme  
- `TimePickerDialogPresenter>>#onOk:`, `TimePickerDialogPresenter>>#onCancel:`, `TimePickerDialogPresenter>>#onChanged:` — sets external callbacks

### Usage

This component is typically used inside a `TimePickerPresenter`.  
It is presented modally and controlled through dialog lifecycle.


"
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
	#category : 'SpecComponentsLibrary-Time',
	#package : 'SpecComponentsLibrary',
	#tag : 'Time'
}

{ #category : 'private' }
TimePickerDialogPresenter >> addSelectionMarker [
"Adds a dot and a line to visually mark the currently selected hour or minute on the clock."
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
"Sets the secondary (accent) color used for button highlights and AM/PM selection."
	additionColor := aColor
]

{ #category : 'building' }
TimePickerDialogPresenter >> buildClockFace [
"Draws the static 12-hour layout with circular hour markers and labels positioned around the center."
	| pointFor |
	pointFor := [ :c :r :angle |
		            | rad |
		            rad := angle degreesToRadians.
		            c + (r * rad cos @ (r * rad sin)) ].

	1 to: 12 do: [ :i |
			| angle pos circle label |
			angle := i * 30 - 90.
			pos := pointFor value: center value: radius - 20 value: angle.
			circle := RSEllipse new
				          radius: 20;
				          color: Color veryLightGray.
			circle translateTo: pos.
			canvas add: circle.
			hourCircles at: i put: circle.
			label := RSLabel new.
			label
				fontSize: 12;
				translateTo: pos.
			canvas add: label ]
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> connectPresenters [
"Attaches click events to toggle between hour/minute mode and switch AM/PM state."
	hourLabel onClick: [ self isHourMode: true ].
	minutesLabel onClick: [ self isHourMode: false ].
	amButton onClick: [ self switchToAm ].
	pmButton onClick: [ self switchToPm ]
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

{ #category : 'private' }
TimePickerDialogPresenter >> drawBackgroundCircle [
"Creates and displays the outer background circle for the clock face."
	| tmp1 |
	tmp1 := RSEllipse new.
	tmp1 radius: radius.
	backgroundCircle := tmp1 color: Color veryLightGray.
	backgroundCircle translateTo: center.
	canvas add: backgroundCircle
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> initializeDialogWindow: arg1 [
"Initializes the modal dialog with title, layout, and OK/Cancel buttons.
Triggers callbacks on user actions."
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
								at: #minute put: selectedMinute.
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
"Switches between hour and minute selection modes.
Updates UI and redrawing accordingly."
	isHourMode := aBool.
	self updateSelectionHighlight.
	self updateClockLabels.
	self updateSelectionMarker
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> isPm: aBool [
	"Sets whether the selected time is PM.
Redraws selection and adjusts labels accordingly."

	isPm := aBool.
	(roassalPresenre canvas shapes includes: selectionLine) ifTrue: [
		canvas removeShape: selectionLine ].
	selectionLine := nil.
	self updateClockLabels
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> mainColor: aColor [
"Sets the primary color used for selection highlights.
Updates the selection marker and AM/PM button visuals."
	mainColor := aColor.
	selectionDot ifNotNil: [ selectionDot color: aColor ].
	self updateSelectionMarker.
	self updateAmPmButtons
]

{ #category : 'events' }
TimePickerDialogPresenter >> onCancel: arg1 [
"Sets the callback to be executed when the dialog is canceled."
	onCancelAction := arg1
]

{ #category : 'events' }
TimePickerDialogPresenter >> onChanged: aBlook [
"Sets a callback block to be triggered when the time is updated by the user."
	onChanged := aBlook
]

{ #category : 'events' }
TimePickerDialogPresenter >> onOk: arg1 [
"Sets the callback to be executed when the user confirms their selection."
	onOkAction := arg1
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedHour [
"Returns the currently selected hour value."
	^ selectedHour
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedHour: arg1 [
	"Updates the selected hour, adjusts label, switches AM/PM if needed, and updates the marker."

	selectedHour := (arg1 max: 0) min: 23.
	hourLabel label: (arg1 < 10
			 ifTrue: [ '0' , arg1 asString ]
			 ifFalse: [ arg1 asString ]).
	selectedHour > 12 ifTrue: [ self switchToPm ] ifFalse: [self switchToAm ].
	self updateSelectionMarker
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedMinute [
"Returns the currently selected minute value."
	^ selectedMinute
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedMinute: arg1 [
"Updates the selected minute, adjusts label, and updates the marker."
	selectedMinute := (arg1 max: 0) min: 59.
	minutesLabel label: (arg1 < 10
			 ifTrue: [ '0' , arg1 asString ]
			 ifFalse: [ arg1 asString ]).
	self updateSelectionMarker
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> switchToAm [
"Switches the internal clock mode to AM (0–11) and updates visuals."
	startHour := 0.
	self isPm: false.
	self updateAmPmButtons
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> switchToPm [
"Switches the internal clock mode to PM (12–23) and updates visuals."
	startHour := 12.
	self isPm: true.
	self updateAmPmButtons
]

{ #category : 'updating' }
TimePickerDialogPresenter >> updateAmPmButtons [
"Visually indicates which AM/PM button is active using background color."
	amButton backgroundColor: (isPm
			 ifTrue: [ '#veryLightGray' ]
			 ifFalse: [ additionColor ]).
	pmButton backgroundColor: (isPm
			 ifTrue: [ additionColor ]
			 ifFalse: [ '#veryLightGray' ])
]

{ #category : 'updating' }
TimePickerDialogPresenter >> updateClockLabels [
"Redraws all hour or minute labels and markers depending on current mode.
Removes previous elements from the canvas and adds new clickable shapes."
	| pointFor windowMorph bounds |
	pointFor := [ :c :r :angle |
		            | rad |
		            rad := angle degreesToRadians.
		            c + (r * rad cos @ (r * rad sin)) ].

	(canvas shapes select: [ :s |
			 (s isKindOf: RSLabel) or: [
					 (s isKindOf: RSLine) or: [
							 (s isKindOf: RSEllipse) and: [
								 s ~~ selectionDot and: [ s ~~ backgroundCircle ] ] ] ] ])
		do: [ :shape | canvas removeShape: shape ].


	hourCircles := Dictionary new.

	isHourMode
		ifTrue: [ "=== HOURS MODE ==="
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
		ifFalse: [ "=== MINUTES MODE ==="
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

						invisibleHitbox := RSEllipse new
							                   radius: 5;
							                   color: Color transparent.
						invisibleHitbox translateTo: startPos.
						canvas add: invisibleHitbox.
						hourCircles at: i put: invisibleHitbox.
						invisibleHitbox
							when: RSMouseClick
							do: [ isHourMode ifFalse: [ self selectedMinute: i ] ]
							for: self ] ].

	windowMorph := self owner ifNotNil: [ :o | o adapter widget ].
	windowMorph ifNotNil: [
			bounds := windowMorph bounds.
			windowMorph bounds: (bounds insetBy: 1).
			windowMorph bounds: bounds ]
]

{ #category : 'updating' }
TimePickerDialogPresenter >> updateSelectionHighlight [
"Highlights the currently active mode (hour or minute) and enables/disables AM/PM controls accordingly."
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

{ #category : 'updating' }
TimePickerDialogPresenter >> updateSelectionMarker [
"Draws or updates the pointer line and dot from center to the selected value on the clock.
Also updates visual highlighting of the selected circle."
	| computeTarget endPoint windowMorph bounds |
	selectedHour ifNil: [ ^ self ].

	computeTarget := [ :center :r :angleDeg |
		                 | rad |
		                 rad := angleDeg degreesToRadians.
		                 center + (r * rad cos @ (r * rad sin)) ].

	endPoint := computeTarget
		            value: center
		            value: radius - 40
		            value: (isHourMode
				             ifTrue: [ selectedHour - startHour \\ 12 * 30 - 90 ]
				             ifFalse: [ selectedMinute * 6 - 90 ]).

	(roassalPresenre canvas shapes includes: selectionLine) ifTrue: [
		canvas removeShape: selectionLine ].
	selectionLine := RSLine new
		                 from: center;
		                 to: endPoint;
		                 color: mainColor;
		                 width: 2.
	canvas add: selectionLine.

	isHourMode ifTrue: [
			hourCircles keysAndValuesDo: [ :i :circle |
					| labelHour |
					labelHour := i = 12
						             ifTrue: [ startHour ]
						             ifFalse: [ startHour + i ].
					circle color: (selectedHour = labelHour
							 ifTrue: [ mainColor ]
							 ifFalse: [ Color veryLightGray ]) ] ].

	"Примусове оновлення"
	windowMorph := self owner ifNotNil: [ :o | o adapter widget ].
	windowMorph ifNotNil: [
			bounds := windowMorph bounds.
			windowMorph bounds: (bounds insetBy: 1).
			windowMorph bounds: bounds ]
]
