Class {
	#name : 'ComboBoxItemSelected',
	#superclass : 'Announcement',
	#instVars : [
		'item'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
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

{ #category : 'initialization' }
ComboBoxItemSelected >> prepareForDelivery [
    "Підготовка до доставки — у нашому випадку нічого не робимо"
    ^ self
]
