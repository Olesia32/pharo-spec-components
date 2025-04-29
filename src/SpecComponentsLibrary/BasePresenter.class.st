Class {
	#name : 'BasePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'styleProperties'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
BasePresenter >> connectPresenters [
    "Стандартне місце для визначення взаємодії між демонстраторами"
]

{ #category : 'as yet unclassified' }
BasePresenter >> defaultLayout [
    "Стандартний макет. За замовчуванням пустий контейнер"
    ^ SpBoxLayout newTopToBottom yourself.
]

{ #category : 'as yet unclassified' }
BasePresenter >> generateAndApplyStyle [

	| styleName |
	^ styleName := StyleManager
		             installGeneratedStyleFrom: self styleProperties
		             in: self application
]

{ #category : 'as yet unclassified' }
BasePresenter >> initializePresenters [
    "Стандартне місце для створення вкладених демонстраторів"
]

{ #category : 'as yet unclassified' }
BasePresenter >> mainPresenter [
    "Повертає головний внутрішній демонстратор, якщо є.
    За замовчуванням повертаємо self. Класи-нащадки можуть перевизначити."
    ^ self
]

{ #category : 'initialization' }
BasePresenter >> setGeneratedStyleProperty: key value: val [

	self styleProperties at: key put: val
]

{ #category : 'accessing' }
BasePresenter >> styleProperties [
	"Гарантовано повертає словник (навіть якщо ще не створений)"

	styleProperties ifNil: [ styleProperties := Dictionary new ].
	^ styleProperties
]
