"
I am a compact time selection presenter that opens a circular clock dialog for choosing hours and minutes.  
I allow the user to select a time using an interactive clock interface with AM/PM support, and display the selected time in a read-only text field.  
Internally, I use `TimePickerDialogPresenter` to render and manage the full-screen time picker. 

### Instance Variables

- _openButton_: a `ButtonPresenter` — button used to open the clock dialog  
- _timeFieldPresenter_: a `TextInputPresenter` — displays the selected time as text (non-editable)  
- _selectedHour_: an `Integer` — currently selected hour (0–23)  
- _selectedMinute_: an `Integer` — currently selected minute (0–59)  
- _onTimeChanged_: a `BlockClosure` — optional callback triggered when the time is changed  
- _dialog_: a `TimePickerDialogPresenter` — modal dialog for selecting time  
- _color_: a `Color` — primary accent color used for the clock UI  
- _additionalColor_: a `Color` — secondary color used for highlighting buttons or active elements

### Public API

- `TimePickerPresenter>>#hour`, `TimePickerPresenter>>#hour:` — gets or sets the selected hour  
- `TimePickerPresenter>>#minutes`, `TimePickerPresenter>>#minutes:` — gets or sets the selected minute  
- `TimePickerPresenter>>#color:`, `TimePickerPresenter>>#additionColor:` — sets the primary and secondary accent colors  

### Events

- `TimePickerPresenter>>#whenTimeChangedDo:` — sets the callback to execute when the time is updated

### Usage

To use a `TimePickerPresenter`, create and embed it into a form or UI layout.  
Clicking the clock button opens a `TimePickerDialogPresenter` in a modal dialog:

```smalltalk
| picker |
picker := TimePickerPresenter new.
picker whenTimeChangedDo: [ Transcript show: 'Time changed to ', picker hour printString, ':', picker minutes printString; cr ].
picker open.

"
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
		'additionalColor'
	],
	#category : 'SpecComponentsLibrary-Time',
	#package : 'SpecComponentsLibrary',
	#tag : 'Time'
}

{ #category : 'accessing' }
TimePickerPresenter >> additionColor: aColor [
"Sets the secondary UI color (used to highlight active states in the dialog, e.g., AM/PM buttons)."
	additionalColor := aColor
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

{ #category : 'showing' }
TimePickerPresenter >> openDialog [
"Creates and opens a TimePickerDialogPresenter as a modal dialog.
Passes the current hour/minute to the dialog, configures its color theme, and handles user confirmation via onOk.
Updates the time field and triggers the onTimeChanged callback if defined."
	| tmp2 |
	dialog := TimePickerDialogPresenter new.
	color ifNotNil: [ dialog mainColor: color ].
	additionalColor ifNotNil: [ dialog additionColor: additionalColor ].
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
