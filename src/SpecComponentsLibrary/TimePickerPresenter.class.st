Class {
	#name : 'TimePickerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'openButton',
		'timeFieldPresenter',
		'selectedHour',
		'selectedMinute'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'layout' }
TimePickerPresenter >> defaultLayout [

	| tmp2 |
	tmp2 := SpBoxLayout newLeftToRight.
	tmp2
		add: timeFieldPresenter;
		add: openButton withConstraints: [ :arg1 | arg1 width: 50 ].
	^ tmp2 yourself
]

{ #category : 'initialization' }
TimePickerPresenter >> initializePresenters [

	timeFieldPresenter := TextInputPresenter new.
	timeFieldPresenter text: '12:00'.
	timeFieldPresenter mainPresenter editable: false.
	openButton := ButtonPresenter new.
	openButton mainPresenter icon: (self iconNamed: 'clock').
	openButton onClick: [ self openDialog ].
	selectedHour := 12.
	selectedMinute := 0
]

{ #category : 'showing' }
TimePickerPresenter >> openDialog [ 
	| inner dialog |

	inner := TimePickerDialogPresenter new.
	inner selectedHour: selectedHour.
	inner selectedMinute: selectedMinute.

	inner onOk: [ :result |
		selectedHour := result at: #hour.
		selectedMinute := result at: #minute.
		timeFieldPresenter text: selectedHour printString , ':' ,
			(selectedMinute < 10 ifTrue: [ '0', selectedMinute asString ] ifFalse: [ selectedMinute asString ]).
	].
	dialog := inner openModal.

]
