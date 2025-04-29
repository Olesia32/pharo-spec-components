Class {
	#name : 'ValidatedPresenter',
	#superclass : 'BasePresenter',
	#instVars : [
		'isValid',
		'errorMessage'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'initialization' }
ValidatedPresenter >> clearValidation [
    "Скидає стан валідації"
    isValid := true.
    errorMessage := ''.
]

{ #category : 'initialization' }
ValidatedPresenter >> errorMessage [
    ^ errorMessage
]

{ #category : 'initialization' }
ValidatedPresenter >> initialize [
    super initialize.
    isValid := true.
    errorMessage := ''.
]

{ #category : 'initialization' }
ValidatedPresenter >> isValid [
    ^ isValid
]

{ #category : 'initialization' }
ValidatedPresenter >> setValid: aBoolean errorMessage: aString [
    "Оновлює стан валідації"
    isValid := aBoolean.
    errorMessage := aString.
]

{ #category : 'initialization' }
ValidatedPresenter >> validate [
    "Виконує валідацію і встановлює стан"
    self subclassResponsibility.
]
