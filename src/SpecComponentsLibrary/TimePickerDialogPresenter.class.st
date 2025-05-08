Class {
	#name : 'TimePickerDialogPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
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
		'onCancelAction'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'adding' }
TimePickerDialogPresenter >> addSelectionMarker [

	selectionDot := RSEllipse new
		                radius: 5;
		                color: Color purple.
	canvas add: selectionDot.
	selectionLine := RSLine new
		                 color: Color purple;
		                 width: 2.
	canvas add: selectionLine
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> buildClockFace [

	| circlePoint innerRadius |
	circlePoint := [ :center :radius :angleDeg |
		               | radians |
		               radians := angleDeg degreesToRadians.
		               center
		               + (radius * radians cos @ (radius * radians sin)) ].
	innerRadius := radius - 20.
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
			hourCircles at: i put: circle ]
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> buildFooterLayout [ 
    SpBoxLayout newLeftToRight spacing: 10; hAlignCenter;
        add: okButton;
        add: cancelButton
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> buildHeaderLayout [ 
    SpBoxLayout newLeftToRight spacing: 5; vAlignCenter;
        add: hourLabel withConstraints: [ :c | c height: 50 ];
        add: (LabelPresenter new fontSize: 16; text: ':') expand: false;
        add: minutesLabel withConstraints: [ :c | c height: 50 ]
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> defaultLayout [ 
    | layout |
    layout := SpBoxLayout newTopToBottom spacing: 10; hAlignCenter.
    layout add: self buildHeaderLayout.
    layout add: roassalPresenre withConstraints: [ :c | c width: 210; height: 210 ].
    layout add: self buildFooterLayout.
    ^ layout
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> drawBackgroundCircle [

	backgroundCircle := RSEllipse new
		                    radius: radius;
		                    color: Color veryLightGray;
		                    borderColor: Color lightGray;
		                    borderWidth: 1.
	backgroundCircle translateTo: center.
	canvas add: backgroundCircle
]

{ #category : 'initialization' }
TimePickerDialogPresenter >> initializePresenters [ 
    hourLabel := ButtonPresenter new fontSize: 16; label: '12'; bold.
    minutesLabel := ButtonPresenter new fontSize: 16; label: '00'; bold.
    hourLabel onClick: [ self isHourMode: true ].
    minutesLabel onClick: [ self isHourMode: false ].

    okButton := ButtonPresenter new label: 'OK'; onClick: [ 
        onOkAction ifNotNil: [ 
            onOkAction value: {
                #hour -> selectedHour.
                #minute -> selectedMinute
            } ].
        self topDialog close 
    ].

    cancelButton := ButtonPresenter new label: 'Скасувати'; onClick: [
        onCancelAction ifNotNil: [ onCancelAction value ].
        self topDialog close
    ].

    roassalPresenre := self newRoassal.
    canvas := roassalPresenre canvas.
    center := 0 @ 0.
    radius := 100.
    hourCircles := Dictionary new.

    self isHourMode: true.
    self drawBackgroundCircle.
    self buildClockFace.
    self addSelectionMarker.
    self updateSelectionMarker.

]

{ #category : 'accessing' }
TimePickerDialogPresenter >> isHourMode: aBoolean [

	isHourMode := aBoolean.
	isHourMode
		ifTrue: [
				hourLabel backgroundColor: '#e5cfee'.
				minutesLabel backgroundColor: '#veryLightGray' ]
		ifFalse: [
				minutesLabel backgroundColor: '#e5cfee'.
				hourLabel backgroundColor: '#veryLightGray' ]
]

{ #category : 'showing' }
TimePickerDialogPresenter >> onCancel: aBlock [

	onCancelAction := aBlock
]

{ #category : 'showing' }
TimePickerDialogPresenter >> onOk: aBlock [

	onOkAction := aBlock
]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> selectHour: arg1 [

	selectedHour := arg1.
	isHourMode
		ifTrue: [
				hourLabel label: selectedHour asString.
				self isHourMode: false ]
		ifFalse: [
				selectedMinute := arg1 * 5.
				minutesLabel label: (selectedMinute printPaddedWith: '0' to: 2) ].
	self updateSelectionMarker
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedHour: h [ 
    selectedHour := h.
    hourLabel label: h asString.
]

{ #category : 'accessing' }
TimePickerDialogPresenter >> selectedMinute: m [ 
    selectedMinute := m.
    minutesLabel label: (m < 10 ifTrue: [ '0', m asString ] ifFalse: [ m asString ]).

]

{ #category : 'as yet unclassified' }
TimePickerDialogPresenter >> updateSelectionMarker [

	| circlePoint pos |
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
	hourCircles keysAndValuesDo: [ :key :circle |
			circle color: (key = selectedHour
					 ifTrue: [ Color purple ]
					 ifFalse: [ Color veryLightGray ]) ]
]
