"
I am an event class used to announce selection changes in `ComboBoxPresenter` and `MultiSelectComboBoxPresenter`.  
I store the selected item or a set of selected items and am broadcast through the `Announcer` system.

"
Class {
	#name : 'ComboBoxItemSelected',
	#superclass : 'Announcement',
	#instVars : [
		'item'
	],
	#category : 'SpecComponentsLibrary-Dropdown',
	#package : 'SpecComponentsLibrary',
	#tag : 'Dropdown'
}

{ #category : 'testing' }
ComboBoxItemSelected class >> handlesAnnouncement: anAnnouncement [ 
    ^ anAnnouncement isKindOf: self
]

{ #category : 'converting' }
ComboBoxItemSelected >> asAnnouncement [
    ^ self
]

{ #category : 'accessing' }
ComboBoxItemSelected >> item [ 
^ item .
]

{ #category : 'accessing' }
ComboBoxItemSelected >> item: anItem [

	 item := anItem 
]
