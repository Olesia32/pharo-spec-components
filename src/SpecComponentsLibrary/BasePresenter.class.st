"
Базовий клас для всіх тих презентерів у SpecComponentsLibrary, до яких мають застосовуватися властивості стилізації.

Надає підтримку стилізації компонентів, зберігає головний внутрішній презентер.
Підкласи повинні реалізовувати метод #initializePresenters та за потреби перевизначати layout.
Щоб отримати доступ до неперевизначених властивостей головного компонента треба прописати mainPresenter.

"
Class {
	#name : 'BasePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'styleProperties',
		'mainPresenter',
		'appliedStyleName',
		'name'
	],
	#category : 'SpecComponentsLibrary-BaseComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'BaseComponents'
}

{ #category : 'style' }
BasePresenter >> backgroundColor: aColor [

	self setGeneratedStyleProperty: #backgroundColor value: aColor.
	self generateAndApplyStyle
]

{ #category : 'style' }
BasePresenter >> bold [

	self setGeneratedStyleProperty: #bold value: true.
	self generateAndApplyStyle
]

{ #category : 'style' }
BasePresenter >> borderColor: aValue [

	self setGeneratedStyleProperty: #borderColor value: aValue.
	self generateAndApplyStyle
]

{ #category : 'style' }
BasePresenter >> borderWidth: aValue [

	self setGeneratedStyleProperty: #borderWidth value: aValue.
	self generateAndApplyStyle
]

{ #category : 'style' }
BasePresenter >> color: aColor [

	self setGeneratedStyleProperty: #color value: aColor
]

{ #category : 'events' }
BasePresenter >> connectPresenters [
    "Стандартне місце для визначення взаємодії між демонстраторами"
]

{ #category : 'layout' }
BasePresenter >> defaultLayout [
	"Стандартний макет. За замовчуванням пустий контейнер"

	self generateAndApplyStyle.
	^ SpBoxLayout newTopToBottom
		  add: mainPresenter;
		  yourself
]

{ #category : 'style' }
BasePresenter >> fontFamily: aFontFamily [

	self setGeneratedStyleProperty: #name value: aFontFamily.
	self generateAndApplyStyle
]

{ #category : 'style' }
BasePresenter >> fontSize: aNumber [

	self setGeneratedStyleProperty: #fontSize value: aNumber.
	self generateAndApplyStyle
]

{ #category : 'style' }
BasePresenter >> generateAndApplyStyle [

	| allStyles |
	appliedStyleName ifNotNil: [
			mainPresenter removeStyle: appliedStyleName.
			allStyles := self application configuration styleSheet styles.
			allStyles := allStyles reject: [ :each |
				          (each isKindOf: SpClassStyle) and: [
					          each name = appliedStyleName ] ].
			self application configuration styleSheet styles: allStyles ].

	appliedStyleName := StyleManager
		                    installGeneratedStyleFrom: self styleProperties
		                    in: self application.
	mainPresenter addStyle: appliedStyleName
	

]

{ #category : 'style' }
BasePresenter >> hResizing: aValue [

	self setGeneratedStyleProperty: #hResizing value: aValue.
	self generateAndApplyStyle
]

{ #category : 'style' }
BasePresenter >> height: aHeight [

	self setGeneratedStyleProperty: #height value: aHeight.
	self generateAndApplyStyle
]

{ #category : 'initialization' }
BasePresenter >> initializePresenters [
	"Стандартне місце для створення вкладених демонстраторів"

	SpNullApplication reset.
]

{ #category : 'style' }
BasePresenter >> italic [

	self setGeneratedStyleProperty: #italic value: true.
	self generateAndApplyStyle
]

{ #category : 'accessing' }
BasePresenter >> mainPresenter [
	"Повертає головний внутрішній демонстратор, якщо є.
    За замовчуванням повертаємо self. Класи-нащадки можуть перевизначити."

	^ mainPresenter 
]

{ #category : 'accessing' }
BasePresenter >> mainPresenter: aPresenter [
mainPresenter := aPresenter 
]

{ #category : 'style' }
BasePresenter >> setGeneratedStyleProperty: key value: val [

	self styleProperties at: key put: val
]

{ #category : 'accessing' }
BasePresenter >> styleProperties [
	"Гарантовано повертає словник (навіть якщо ще не створений)"

	styleProperties ifNil: [ styleProperties := Dictionary new ].
	^ styleProperties
]

{ #category : 'style' }
BasePresenter >> vResizing: aValue [

	self setGeneratedStyleProperty: #vResizing value: aValue.
	self generateAndApplyStyle
]

{ #category : 'style' }
BasePresenter >> width: aWidth [

	self setGeneratedStyleProperty: #width value: aWidth.
	self generateAndApplyStyle
]
