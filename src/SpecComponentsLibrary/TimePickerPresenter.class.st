Class {
	#name : 'TimePickerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'openButton',
		'onOkAction',
		'onCancelAction',
		'timeFieldPresenter',
		'selectedHour',
		'selectedMinute'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'layout' }
TimePickerPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: timeFieldPresenter;
		  add: openButton withConstraints: [:c | c width: 50];
		  yourself
]

{ #category : 'initialization' }
TimePickerPresenter >> initializeDialogWindow: aDialogPresenter [

	aDialogPresenter centered.
	aDialogPresenter layout: self defaultDialogLayout.
	aDialogPresenter
		addButton: 'Скасувати' do: [ aDialogPresenter close ];
		addButton: 'OK' do: [
				aDialogPresenter beOk.
				aDialogPresenter close ]
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
    selectedMinute := 0.
]

{ #category : 'showing' }
TimePickerPresenter >> onCancel: aBlock [ 
 onCancelAction := aBlock 
]

{ #category : 'showing' }
TimePickerPresenter >> onOk: aBlock [ 
 onOkAction := aBlock 
]

{ #category : 'showing' }
TimePickerPresenter >> openDialog [ 
    | dialog inner |
    inner := TimePickerDialogPresenter new.
    inner selectedHour: selectedHour.
    inner selectedMinute: selectedMinute.
    inner onOk: [ :result |
        selectedHour := result at: #hour.
        selectedMinute := result at: #minute.
        timeFieldPresenter text: selectedHour printString , ':' , (selectedMinute printPaddedWith: '0' to: 2).
        onOkAction ifNotNil: [ onOkAction value: result ] ].
    inner onCancel: [ onCancelAction ifNotNil: [ onCancelAction value ] ].

    dialog := inner openModal.
    dialog title: 'Оберіть час'
]
