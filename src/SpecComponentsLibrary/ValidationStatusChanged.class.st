"
Подія, що оголошується при зміні статусу валідації поля.

Може містити інформацію про поле, статус (валідне/невалідне), повідомлення про помилку. Використовується для реакції на зміну валідності в інтерфейсі.

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
