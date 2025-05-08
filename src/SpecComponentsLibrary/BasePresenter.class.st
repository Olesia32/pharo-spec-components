Class {
	#name : 'BasePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'styleProperties',
		'mainPresenter',
		'appliedStyleName',
		'name'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
BasePresenter >> applyNamedStyle: aStyleName [ 
	self mainPresenter addStyle: aStyleName
]

{ #category : 'accessing' }
BasePresenter >> backgroundColor: aColor [

	self setGeneratedStyleProperty: #backgroundColor value: aColor.
	self generateAndApplyStyle
]

{ #category : 'accessing' }
BasePresenter >> bold [

	self setGeneratedStyleProperty: #bold value: true.
	self generateAndApplyStyle
]

{ #category : 'accessing' }
BasePresenter >> borderColor: aValue [

	self setGeneratedStyleProperty: #borderColor value: aValue.
	self generateAndApplyStyle
]

{ #category : 'accessing' }
BasePresenter >> borderWidth: aValue [

	self setGeneratedStyleProperty: #borderWidth value: aValue.
	self generateAndApplyStyle
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

	self setGeneratedStyleProperty: #name value: aFontFamily.
	self generateAndApplyStyle
]

{ #category : 'accessing' }
BasePresenter >> fontSize: aNumber [

	self setGeneratedStyleProperty: #fontSize value: aNumber.
	self generateAndApplyStyle
]

{ #category : 'as yet unclassified' }
BasePresenter >> generateAndApplyStyle [

	appliedStyleName ifNotNil: [
		mainPresenter removeStyle: appliedStyleName ].

	appliedStyleName := StyleManager
		                    installGeneratedStyleFrom: self styleProperties
		                    in: self application.
	mainPresenter addStyle: appliedStyleName
]

{ #category : 'accessing' }
BasePresenter >> hResizing: aValue [

	self setGeneratedStyleProperty: #hResizing value: aValue.
	self generateAndApplyStyle
]

{ #category : 'accessing' }
BasePresenter >> height: aHeight [

	self setGeneratedStyleProperty: #height value: aHeight.
	self generateAndApplyStyle
]

{ #category : 'as yet unclassified' }
BasePresenter >> initializePresenters [
	"Стандартне місце для створення вкладених демонстраторів"

	SpNullApplication reset.
]

{ #category : 'accessing' }
BasePresenter >> italic [

	self setGeneratedStyleProperty: #italic value: true.
	self generateAndApplyStyle
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

{ #category : 'as yet unclassified' }
BasePresenter >> propagateApplication [ 
	| subs |
	self application ifNil: [ ^self ].
	
	subs := (self instVarNamed: 'focusOrder') ifNil: [ ^self ].

	subs do: [ :p |
		(p respondsTo: #application:) ifTrue: [ p application: self application ].
		(p respondsTo: #propagateApplication) ifTrue: [ p propagateApplication ] ].
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
BasePresenter >> vResizing: aValue [

	self setGeneratedStyleProperty: #vResizing value: aValue.
	self generateAndApplyStyle
]

{ #category : 'accessing' }
BasePresenter >> width: aWidth [

	self setGeneratedStyleProperty: #width value: aWidth.
	self generateAndApplyStyle
]
