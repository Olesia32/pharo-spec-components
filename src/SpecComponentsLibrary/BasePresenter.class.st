Class {
	#name : 'BasePresenter',
	#superclass : 'SpPresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'api' }
BasePresenter >> addStyle: aStyleName [
    "Додає стиль до демонстратора"
    self mainPresenter ifNotNil: [ :presenter |
        presenter addStyle: aStyleName]
]

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
BasePresenter >> initializePresenters [
    "Стандартне місце для створення вкладених демонстраторів"
]

{ #category : 'as yet unclassified' }
BasePresenter >> mainPresenter [
    "Повертає головний внутрішній демонстратор, якщо є.
    За замовчуванням повертаємо self. Класи-нащадки можуть перевизначити."
    ^ self
]
