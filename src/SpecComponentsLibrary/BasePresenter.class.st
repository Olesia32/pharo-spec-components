"
I am the base class for all styled presenters in the `SpecComponentsLibrary`.  
I provide support for component styling via generated style properties.  
Subclasses use me when they need to apply and update visual styles dynamically, such as font size, color, background, borders, and sizing.

I also store the main internal presenter (e.g., a label, button, or input field), accessible via `#mainPresenter`.  
All styling is applied to this `mainPresenter`, so subclasses that wrap another presenter must assign it via `mainPresenter:`.

This allows external users to access and configure inner presenter behavior (such as validation, event bindings, etc.) without needing to expose it manually. Subclasses should implement `#initializePresenters` to construct inner components.

### Instance Variables

- _styleProperties_: a `Dictionary` — stores the generated style attributes (e.g., font size, color)  
- _mainPresenter_: a `SpPresenter` — the internal child presenter to which style is applied  
- _appliedStyleName_: a `String` — name of the currently applied style in the application’s style sheet  

### Public API

`BasePresenter>>#mainPresenter`, `BasePresenter>>#mainPresenter:` — get or assign the internal component that receives styles
`BasePresenter>>#styleProperties` — access the dictionary of current style attributes
`BasePresenter>>#backgroundColor:` — sets the background color
`BasePresenter>>#color:` — sets the foreground/text color
`BasePresenter>>#borderColor:`, `BasePresenter>>#borderWidth:` — sets border color and width
`BasePresenter>>#width:`, `BasePresenter>>#height:` — sets explicit dimensions
`BasePresenter>>#fontSize:`, `BasePresenter>>#fontFamily:` — sets text appearance
`BasePresenter>>#bold`, `BasePresenter>>#italic` — toggles bold or italic text
`BasePresenter>>#hResizing:`, `BasePresenter>>#vResizing:` — sets horizontal and vertical resizing policies

"
Class {
	#name : 'BasePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'styleProperties',
		'mainPresenter',
		'appliedStyleName'
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
"Removes the previously applied generated style (if any) from the application’s stylesheet.
Creates a new style based on styleProperties using StyleManager, stores its name, and applies it to the mainPresenter."
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

	SpNullApplication reset
]

{ #category : 'style' }
BasePresenter >> italic [

	self setGeneratedStyleProperty: #italic value: true.
	self generateAndApplyStyle
]

{ #category : 'accessing' }
BasePresenter >> mainPresenter [
	"Returns the mainPresenter, or self if not explicitly set.
Subclasses typically override this or assign it in #initializePresenters."

	^ mainPresenter
]

{ #category : 'accessing' }
BasePresenter >> mainPresenter: aPresenter [
"Sets the internal mainPresenter to the given presenter.
This presenter will receive all styling and be displayed in the default layout.
Used in subclasses to assign the primary visual component (e.g., a label or input field)."
	mainPresenter := aPresenter
]

{ #category : 'style' }
BasePresenter >> setGeneratedStyleProperty: key value: val [
"Returns the style dictionary used for generating styles.
If it hasn't been created yet, initializes it as a new Dictionary."
	self styleProperties at: key put: val
]

{ #category : 'accessing' }
BasePresenter >> styleProperties [

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
