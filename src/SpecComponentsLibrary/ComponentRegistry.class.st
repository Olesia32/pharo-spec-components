Class {
	#name : 'ComponentRegistry',
	#superclass : 'Object',
	#instVars : [
		'registry'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'private' }
ComponentRegistry >> classFor: aName [
    "Повертає клас за ім'ям компонента"
    ^ registry at: aName ifAbsent: [ nil ].
]

{ #category : 'private' }
ComponentRegistry >> create: aName [
    "Створює екземпляр компонента за ім'ям"
    | klass |
    klass := self classFor: aName.
    ^ klass ifNotNil: [ klass new ]
        ifNil: [ self error: 'Component not found: ', aName ].
]

{ #category : 'initialization' }
ComponentRegistry >> initialize [
    "Ініціалізація реєстру компонентів"
    registry := Dictionary new.

]

{ #category : 'registration' }
ComponentRegistry >> register: aName with: aPresenterClass [
    "Реєструє новий компонент за ім'ям"
    registry at: aName put: aPresenterClass.
]
