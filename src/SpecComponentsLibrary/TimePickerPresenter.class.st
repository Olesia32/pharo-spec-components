Class {
	#name : 'TimePickerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'openButton',
		'timeFieldPresenter',
		'selectedHour',
		'selectedMinute',
		'onTimeChanged',
		'dialog',
		'color',
		'additionalColor',
		'okButtonlabel',
		'cancelButtonLabel'
	],
	#category : 'SpecComponentsLibrary-Time',
	#package : 'SpecComponentsLibrary',
	#tag : 'Time'
}

{ #category : 'as yet unclassified' }
TimePickerPresenter >> additionColor [ 
 ^ additionalColor 
]

{ #category : 'accessing' }
TimePickerPresenter >> additionColor: aColor [
"Sets the secondary UI color (used to highlight active states in the dialog, e.g., AM/PM buttons)."
	additionalColor := aColor
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> cancelButtonLabel [
  ^ cancelButtonLabel 
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> cancelButtonLabel: aLabel [

	cancelButtonLabel := aLabel
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> color [
  ^ color
]

{ #category : 'accessing' }
TimePickerPresenter >> color: aColor [
"Sets the primary color used in the time selection dialog (e.g., selection markers and highlights)."
	color := aColor
]

{ #category : 'layout' }
TimePickerPresenter >> defaultLayout [

	| tmp1 |
	tmp1 := SpBoxLayout newLeftToRight.
	tmp1
		add: timeFieldPresenter;
		add: openButton withConstraints: [ :arg1 | arg1 width: 100 ].
	^ tmp1 yourself
]

{ #category : 'accessing' }
TimePickerPresenter >> hour [
"Returns the currently selected hour."
	^ selectedHour
]

{ #category : 'accessing' }
TimePickerPresenter >> hour: aHour [
	selectedHour := aHour
]

{ #category : 'initialization' }
TimePickerPresenter >> initializePresenters [

	timeFieldPresenter := TextInputPresenter new.
	timeFieldPresenter text: '12:00'.
	timeFieldPresenter mainPresenter editable: false.
	openButton := ButtonPresenter new.
	openButton mainPresenter icon: (self iconNamed: 'clock').
	openButton onClick: [ self openDialog ].
	selectedHour := 0.
	selectedMinute := 0
]

{ #category : 'accessing' }
TimePickerPresenter >> minutes [
"Returns the currently selected minute."
	^ selectedMinute
]

{ #category : 'accessing' }
TimePickerPresenter >> minutes: aMinutes [
	selectedMinute := aMinutes
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> okButtonLabel [
  ^ okButtonlabel 
]

{ #category : 'as yet unclassified' }
TimePickerPresenter >> okButtonLabel: aLabel [
  okButtonlabel := aLabel 
]

{ #category : 'showing' }
TimePickerPresenter >> openDialog [
	"Creates and opens a TimePickerDialogPresenter as a modal dialog.
Passes the current hour/minute to the dialog, configures its color theme, and handles user confirmation via onOk.
Updates the time field and triggers the onTimeChanged callback if defined."

	| tmp2 |
	dialog := TimePickerDialogPresenter new.
	color ifNotNil: [ dialog mainColor: color ].
	additionalColor ifNotNil: [ dialog additionColor: additionalColor ].
	okButtonlabel ifNotNil: [ dialog okButtonLabel: okButtonlabel ].
	cancelButtonLabel ifNotNil: [
		dialog cancelButtonLabel: cancelButtonLabel ].
	dialog
		selectedHour: selectedHour;
		selectedMinute: selectedMinute;
		onOk: [ :arg1 |
				selectedHour := arg1 at: #hour.
				selectedMinute := arg1 at: #minute.
				timeFieldPresenter text:
						selectedHour printString , ':' , (selectedMinute < 10
								 ifTrue: [ '0' , selectedMinute asString ]
								 ifFalse: [ selectedMinute asString ]).
				onTimeChanged ifNotNil: [ onTimeChanged value ] ].
	tmp2 := dialog openModal
]

{ #category : 'events' }
TimePickerPresenter >> whenTimeChangedDo: aBlock [
"Sets a callback block that will be triggered when the time is changed by the user through the dialog."
	onTimeChanged := aBlock
]
