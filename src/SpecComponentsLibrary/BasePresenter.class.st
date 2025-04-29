Class {
	#name : 'BasePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'styleProperties',
		'mainPresenter'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
BasePresenter >> backgroundColor: aColor [

	self setGeneratedStyleProperty: #backgroundColor value: aColor
]

{ #category : 'accessing' }
BasePresenter >> bold [

	self setGeneratedStyleProperty: #bold value: true
]

{ #category : 'accessing' }
BasePresenter >> color: aColor [

	self setGeneratedStyleProperty: #color value: aColor
]

{ #category : 'as yet unclassified' }
BasePresenter >> connectPresenters [
    "Стандартне місце для визначення взаємодії між демонстраторами"
]

{ #category : 'as yet unclassified' }
BasePresenter >> defaultLayout [
	"Стандартний макет. За замовчуванням пустий контейнер"
self generateAndApplyStyle.
	^ SpBoxLayout newTopToBottom
		  add: mainPresenter;
		  yourself
]

{ #category : 'font description' }
BasePresenter >> fontFamily: aFontFamily [

	self setGeneratedStyleProperty: #name value: aFontFamily
]

{ #category : 'accessing' }
BasePresenter >> fontSize: aNumber [

	self setGeneratedStyleProperty: #fontSize value: aNumber
]

{ #category : 'as yet unclassified' }
BasePresenter >> generateAndApplyStyle [

	| styleName |
	styleName := StyleManager
		               installGeneratedStyleFrom: self styleProperties
		               in: self application.
	mainPresenter addStyle: styleName
]

{ #category : 'accessing' }
BasePresenter >> height: aHeight [

	self setGeneratedStyleProperty: #height value: aHeight
]

{ #category : 'as yet unclassified' }
BasePresenter >> initializePresenters [
    "Стандартне місце для створення вкладених демонстраторів"
]

{ #category : 'accessing' }
BasePresenter >> italic [

	self setGeneratedStyleProperty: #italic value: true
]

{ #category : 'as yet unclassified' }
BasePresenter >> mainPresenter [
	"Повертає головний внутрішній демонстратор, якщо є.
    За замовчуванням повертаємо self. Класи-нащадки можуть перевизначити."

	^ mainPresenter 
]

{ #category : 'accessing' }
BasePresenter >> mainPresenter: aPresenter [
mainPresenter := aPresenter 
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

{ #category : 'accessing' }
BasePresenter >> width: aWidth [

	self setGeneratedStyleProperty: #width value: aWidth
]
