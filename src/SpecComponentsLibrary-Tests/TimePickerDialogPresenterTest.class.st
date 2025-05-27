Class {
	#name : 'TimePickerDialogPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'dialog'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'running' }
TimePickerDialogPresenterTest >> setUp [ 
	super setUp.
	dialog := TimePickerDialogPresenter new.
	dialog initializePresenters.
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testAdditionColor [

	dialog additionColor: Color blue.
	self
		assert: (dialog instVarNamed: 'additionColor')
		equals: Color blue
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testIsHourMode [

	dialog isHourMode: false.
	self deny: (dialog instVarNamed: 'isHourMode').
	self deny: (dialog instVarNamed: 'amButton') mainPresenter isEnabled.

	dialog isHourMode: true.
	self assert: (dialog instVarNamed: 'isHourMode').
	self assert: (dialog instVarNamed: 'amButton') mainPresenter isEnabled
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testIsPm [
	dialog isPm: true.
	self assert: (dialog instVarNamed: 'isPm').

	dialog isPm: false.
	self deny: (dialog instVarNamed: 'isPm').
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testMainColor [
	| newColor |
	newColor := Color red.
	dialog mainColor: newColor.
	self assert: (dialog instVarNamed: 'mainColor') equals: newColor
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testOnCancel [
	| cancelled |
	cancelled := false.
	dialog onCancel: [ cancelled := true ].
	(dialog instVarNamed: 'onCancelAction') value.
	self assert: cancelled.
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testOnOk [

	| result dict |
	result := nil.

	dict := Dictionary new.
	dict at: #hour put: 6.
	dict at: #minute put: 15.

	dialog onOk: [ :time | result := time ].
	(dialog instVarNamed: 'onOkAction') value: dict.
	self assert: (result at: #hour) equals: 6.
	self assert: (result at: #minute) equals: 15.

	self assert: (result at: #hour) equals: 6.
	self assert: (result at: #minute) equals: 15
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testSelectedHour [

	dialog selectedHour: 15.
	self assert: dialog selectedHour equals: 15.

	dialog selectedHour: -1.
	self assert: dialog selectedHour >= 0.

	dialog selectedHour: 999.
	self assert: dialog selectedHour <= 23.

	dialog selectedHour: 9.
	self assert: (dialog instVarNamed: 'hourLabel') label equals: '09'.
	self deny: (dialog instVarNamed: 'isPm').

	dialog selectedHour: 15.
	self assert: dialog selectedHour equals: 15.
	self assert: (dialog instVarNamed: 'hourLabel') label equals: '15'.
	self assert: (dialog instVarNamed: 'isPm')
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testSelectedMinute [

	dialog selectedMinute: 45.
	self assert: dialog selectedMinute equals: 45.
	self assert: (dialog instVarNamed: 'minutesLabel') label equals: '45'.

	dialog selectedMinute: -1.
	self assert: dialog selectedMinute >= 0.

	dialog selectedMinute: 100.
	self assert: dialog selectedMinute <= 59.

	dialog selectedMinute: 5.
	self assert: dialog selectedMinute equals: 5.
	self assert: (dialog instVarNamed: 'minutesLabel') label equals: '05'
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testSwitchToAm [

	dialog switchToAm.
	self assert: (dialog instVarNamed: 'startHour') equals: 0.
	self deny: (dialog instVarNamed: 'isPm')
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testSwitchToPm [

	dialog switchToPm.
	self assert: (dialog instVarNamed: 'startHour') equals: 12.
	self assert: (dialog instVarNamed: 'isPm')
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testUpdateClockLabels [

	| texts tickMarks |
	"AM mode"
	dialog switchToAm. "startHour := 0"
	dialog isHourMode: true.
	dialog updateClockLabels.

	texts := ((dialog instVarNamed: 'canvas') shapes select: [ :s |
			          (s isKindOf: RSLabel) and: [
					          s text
						          ifNotNil: [ s text allSatisfy: [ :c | c isDigit ] ]
						          ifNil: [ false ] ] ]) collect: [ :lbl |
		         lbl text asInteger ].
	self assert: texts size equals: 12.
	self assert: texts asSet equals: (0 to: 11) asSet.
	dialog switchToPm. "startHour := 12"
	dialog isHourMode: true.
	dialog updateClockLabels.

	texts := ((dialog instVarNamed: 'canvas') shapes select: [ :s |
			          (s isKindOf: RSLabel) and: [
					          s text
						          ifNotNil: [ s text allSatisfy: [ :c | c isDigit ] ]
						          ifNil: [ false ] ] ]) collect: [ :lbl |
		         lbl text asInteger ].
	self assert: texts size equals: 12.
	self assert: texts asSet equals: (12 to: 23) asSet.
	
   dialog isHourMode: false.
	dialog updateClockLabels.
	tickMarks := (dialog instVarNamed: 'canvas') shapes select: [ :s | s isKindOf: RSLine ].
	self assert: tickMarks size >= 60.
]

{ #category : 'tests' }
TimePickerDialogPresenterTest >> testUpdateSelectionMarker [

	dialog selectedHour: 3.
	dialog isHourMode: true.
	dialog updateSelectionMarker.

	self assert: (dialog instVarNamed: 'selectionLine') notNil.
	self assert: (dialog instVarNamed: 'selectionDot') notNil.
	self assert:
		((dialog instVarNamed: 'canvas') shapes includes:
			 (dialog instVarNamed: 'selectionLine')).
	self assert:
		((dialog instVarNamed: 'canvas') shapes includes:
			 (dialog instVarNamed: 'selectionDot'))
]
