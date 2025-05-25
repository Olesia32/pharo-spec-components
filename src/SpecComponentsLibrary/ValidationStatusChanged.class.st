"
I am an event (announcement) that is triggered when the validation status of an input field changes.  
I carry information about the new validation state (valid or invalid) and can be used by UI components to react — for example, by showing a warning, enabling/disabling buttons, or logging changes.

This event is announced by `TextInputPresenter` during validation and can be listened to using `onValidationChangedDo:`.

"
Class {
	#name : 'ValidationStatusChanged',
	#superclass : 'Announcement',
	#instVars : [
		'newValue'
	],
	#category : 'SpecComponentsLibrary-ValidatedInput',
	#package : 'SpecComponentsLibrary',
	#tag : 'ValidatedInput'
}

{ #category : 'accessing' }
ValidationStatusChanged >> newValue [ 
    ^ newValue
]

{ #category : 'accessing' }
ValidationStatusChanged >> newValue: aValue [ 
    newValue := aValue
]
