"
Презентер для вибору часу за допомогою інтерактивного годинника.

Підтримує вибір годин та хвилин, перемикання між AM/PM та відображення обраного значення. Інтегрується у DynamicFormBuilder як спеціалізоване поле.

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
 additionalColor := aColor 
]

{ #category : 'accessing' }
TimePickerPresenter >> color: aColor [
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
  ^ selectedMinute 
]

{ #category : 'accessing' }
TimePickerPresenter >> minutes: aMinutes [
  selectedMinute := aMinutes 
]

{ #category : 'showing' }
TimePickerPresenter >> openDialog [

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
  onTimeChanged := aBlock.
]
