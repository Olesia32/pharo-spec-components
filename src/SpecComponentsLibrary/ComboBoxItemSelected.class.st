"
Клас події, який оголошується при зміні вибору в ComboBox або MultiSelectComboBox.

Містить вибраний елемент (або множину елементів) і використовується для передачі події через Announcer.

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
