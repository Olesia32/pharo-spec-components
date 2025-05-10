"
Компонент для динамічного створення форм.

Підтримує побудову TextInputPresenter, CheckBoxPresenter, CheckBoxGroupPresenter, RadioGroupPresenter, SpDatePresenter, TimePickerPresenter, SpDropList, ComboBoxPresenter, MultiSelectComboBoxPresenter.
Має заголовок та кнопки 'Продовжити/Скасувати', які можна приховати.
Підтримує стилізацію через клас FormStyle.
Має метод для збір значень всіх полів у словник.

"
Class {
	#name : 'DynamicFormBuilder',
	#superclass : 'SpPresenter',
	#instVars : [
		'fields',
		'fieldLabels',
		'fieldPresenters',
		'formData',
		'customTopPresenter',
		'submitButton',
		'backButton',
		'headerLabel',
		'onSubmitAction',
		'onBackAction',
		'formStyle',
		'isHideHeader',
		'isHideButtons'
	],
	#category : 'SpecComponentsLibrary-AdvancedComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'AdvancedComponents'
}

{ #category : 'style' }
DynamicFormBuilder >> applyInputStyleTo: presenter [ 
	formStyle inputFontSize ifNotNil: [ :f | presenter fontSize: f ].
	formStyle inputBackground ifNotNil: [ :c |
		(presenter respondsTo: #backgroundColor:) ifTrue: [
			presenter backgroundColor: c ] ].
	formStyle inputWidth ifNotNil: [ :f | presenter width: f ].
	formStyle inputHeight ifNotNil: [ :c | presenter height: c ].
	formStyle inputBorderWidth ifNotNil: [ :f |
		(presenter respondsTo: #borderWidth:) ifTrue: [
			presenter borderWidth: f ] ].
	formStyle inputBorderColor ifNotNil: [ :c |
		(presenter respondsTo: #borderColor:) ifTrue: [
			presenter borderColor: c ] ].
]

{ #category : 'style' }
DynamicFormBuilder >> applyLabelStyle: arg1 [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 |
	(arg1 isKindOf: LabelPresenter) ifFalse: [ ^ self ].
	tmp3 := tmp1 := formStyle labelFontSize.
	tmp3 ifNotNil: [ arg1 fontSize: tmp1 ].
	tmp4 := tmp1 := formStyle fontFamily.
	tmp4 ifNotNil: [ arg1 fontFamily: tmp1 ].
	tmp5 := tmp1 := formStyle isLabelBold.
	tmp5 ifNotNil: [ arg1 bold: tmp1 ].
	tmp6 := tmp1 := formStyle isLabelItalic.
	tmp6 ifNotNil: [ arg1 italic: tmp1 ].
	tmp7 := tmp2 := formStyle labelColor.
	tmp7 ifNotNil: [ arg1 color: tmp2 ]
]

{ #category : 'style' }
DynamicFormBuilder >> applyStyleToAllPresenters [

	| allPresenters |
	formStyle ifNil: [ ^ self ].
	allPresenters := fieldPresenters copy.

	headerLabel ifNotNil: [
			formStyle headerFontSize ifNotNil: [ :f | headerLabel fontSize: f ].
			formStyle fontFamily ifNotNil: [ :f | headerLabel fontFamily: f ].
			formStyle isHeaderBold ifNotNil: [ :f | headerLabel bold: f ].
			formStyle isHeaderItalic ifNotNil: [ :f | headerLabel italic: f ].
			formStyle headerColor ifNotNil: [ :c | headerLabel color: c ] ].

	submitButton ifNotNil: [
		allPresenters add: #__submit__ -> submitButton ].
	backButton ifNotNil: [ allPresenters add: #__back__ -> backButton ].

	allPresenters do: [ :assoc |
			| presenter |
			presenter := assoc value.
         	Transcript crShow: presenter class name, ' – ', (self isInputComponent: presenter) printString.

			self applyLabelStyle: presenter.

			(self isInputComponent: presenter) ifTrue: [
				self applyInputStyleTo: presenter ].

			(presenter isKindOf: ButtonPresenter) ifTrue: [
					formStyle labelFontSize ifNotNil: [ :f | presenter fontSize: f ].
					formStyle fontFamily ifNotNil: [ :f | presenter fontFamily: f ].
					formStyle isLabelBold ifNotNil: [ :f | presenter bold: f ].
					formStyle isLabelItalic ifNotNil: [ :f | presenter italic: f ].
					formStyle labelColor ifNotNil: [ :c | presenter color: c ].
					formStyle buttonWidth ifNotNil: [ :f | presenter width: f ].
					formStyle buttonHeight ifNotNil: [ :c | presenter height: c ] ] ]
]

{ #category : 'accessing' }
DynamicFormBuilder >> backButtonLabel: arg1 [

	backButton label: arg1
]

{ #category : 'creation' }
DynamicFormBuilder >> checkbox: aKey label: aLabel [

	| presenter |
	presenter := CheckboxPresenter new mainPresenter label: aLabel.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'creation' }
DynamicFormBuilder >> checkboxGroup: aKey label: aLabel items: itemsList columns: columnCount frame: aBoolean [

	| presenter |
	presenter := CheckboxGroupPresenter new.
	presenter
		items: itemsList;
		сolumnCount: columnCount;
		showTitle: false;
		showFrame: aBoolean.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'accessing' }
DynamicFormBuilder >> collectValues [

	| result |
	result := Dictionary new.

	fieldPresenters do: [ :assoc |
			| key presenter value |
			key := assoc key.
			presenter := assoc value.

			value := (presenter isKindOf: TextInputPresenter)
				         ifTrue: [ presenter text ]
				         ifFalse: [
						         (presenter isKindOf: SpDropListPresenter)
							         ifTrue: [ presenter selectedItem ]
							         ifFalse: [
									         (presenter isKindOf: ComboBoxPresenter)
										         ifTrue: [ presenter selectedItem ]
										         ifFalse: [
												         (presenter isKindOf: MultiSelectComboBoxPresenter)
													         ifTrue: [ presenter selectedItems ]
													         ifFalse: [
															         (presenter isKindOf: SpDatePresenter)
																         ifTrue: [ presenter date ]
																         ifFalse: [
																		         (presenter isKindOf: TimePickerPresenter)
																			         ifTrue: [
																					         Dictionary new
																						         at: #hour put: presenter hour;
																						         at: #minute put: presenter minutes;
																						         yourself ]
																			         ifFalse: [
																					         (presenter isKindOf: CheckboxPresenter)
																						         ifTrue: [
																						         presenter mainPresenter state ]
																						         ifFalse: [
																								         (presenter isKindOf:
																									          RadioGroupPresenter)
																									         ifTrue: [ presenter itemSelected ]
																									         ifFalse: [
																											         (presenter isKindOf:
																												          CheckboxGroupPresenter)
																												         ifTrue: [
																												         presenter selectedItems ]
																												         ifFalse: [ nil ] ] ] ] ] ] ] ] ].


			result at: key put: value ].
		^ result
]

{ #category : 'creation' }
DynamicFormBuilder >> comboBox: aKey label: aLabel items: itemsList [

	| presenter |
	presenter := ComboBoxPresenter new.
	presenter
		items: itemsList.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'initialization' }
DynamicFormBuilder >> connectPresenters [

	submitButton onClick: [
			(onSubmitAction isNil or: [ self collectValues isNil ]) ifTrue: [
				^ self ].
			nil.
			self validateFields ifTrue: [
				onSubmitAction value: self collectValues ] ].
	backButton onClick: [
		onBackAction ifNotNil: [ onBackAction value: self ] ]
]

{ #category : 'creation' }
DynamicFormBuilder >> datePicker: aKey label: aLabel [

	| presenter |
	presenter := SpDatePresenter new.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'layout' }
DynamicFormBuilder >> defaultLayout [
	| layout headerArea formGrid buttonBar currentRow |
	self applyStyleToAllPresenters.
	layout := SpBoxLayout newVertical spacing: 0.
	headerArea := SpBoxLayout newVertical.
	headerArea
		hAlignCenter;
		spacing: 5.
	customTopPresenter ifNotNil: [ headerArea add: customTopPresenter ].
	isHideHeader ifFalse: [ headerArea add: headerLabel expand: false ].
	layout add: headerArea expand: false.

	formGrid := SpGridLayout new.
	formGrid beColumnNotHomogeneous.
	currentRow := 1.
	fieldPresenters do: [ :assoc |
		| key presenter labelPresenter |
		key := assoc key.
		presenter := assoc value.
		labelPresenter := LabelPresenter new text: (fieldLabels at: key ifAbsent: '').
		self applyLabelStyle: labelPresenter.
		formGrid
			add: labelPresenter atPoint: 1 @ currentRow;
			add: presenter atPoint: 2 @ currentRow span: 2 @ 1.
		currentRow := currentRow + 1 ].
	layout add: formGrid withConstraints: [ :c | c height: fieldPresenters size * 40 ].

	isHideButtons ifFalse: [
		buttonBar := SpBoxLayout newLeftToRight.
		buttonBar
			hAlignCenter;
			spacing: 20;
			add: submitButton expand: false;
			add: backButton expand: false.
		layout add: buttonBar expand: false
	].

	^ layout yourself

]

{ #category : 'creation' }
DynamicFormBuilder >> dropList: aKey label: aLabel items: itemsList [

	| presenter |
	presenter := SpDropListPresenter new.
	presenter
		items: itemsList.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'accessing' }
DynamicFormBuilder >> header: arg1 [

	headerLabel text: arg1
]

{ #category : 'accessing' }
DynamicFormBuilder >> hideButtons [

	isHideButtons := true.
	self defaultLayout
]

{ #category : 'accessing' }
DynamicFormBuilder >> hideHeader [

	isHideHeader := true.
	self defaultLayout
]

{ #category : 'initialization' }
DynamicFormBuilder >> initializePresenters [

	fields ifNil: [ fields := #(  ) ] ifNotNil: [ fields ].
	fieldPresenters := OrderedCollection new.
	formData := Dictionary new.
	fieldLabels := Dictionary new.
	isHideHeader := false.
	isHideButtons := false.
	submitButton := ButtonPresenter new.
	submitButton label: 'Продовжити'.
	backButton := ButtonPresenter new.
	backButton label: 'Скасувати'.
	headerLabel := LabelPresenter new.
	headerLabel text: ''.
	fieldPresenters addAll: (fields collect: [ :arg1 |
				 | tmp1 tmp2 |
				 tmp2 := arg1 at: #key.
				 tmp1 := self createPresenterFromSpec: arg1.
				 tmp2 -> tmp1 ])
]

{ #category : 'testing' }
DynamicFormBuilder >> isInputComponent: presenter [ 
  ^ #(
		TextInputPresenter
		SpDropListPresenter
		ComboBoxPresenter
		MultiSelectComboBoxPresenter
		SpDatePresenter
		TimePickerPresenter
	) anySatisfy: [ :cls | presenter isKindOf: (Smalltalk at: cls) ]
]

{ #category : 'creation' }
DynamicFormBuilder >> multiComboBox: aKey label: aLabel items: itemsList [

	| presenter |
	presenter := MultiSelectComboBoxPresenter new.
	presenter
		items: itemsList.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'events' }
DynamicFormBuilder >> onBack: arg1 [

	onBackAction := arg1
]

{ #category : 'events' }
DynamicFormBuilder >> onSubmit: arg1 [

	onSubmitAction := arg1
]

{ #category : 'accessing' }
DynamicFormBuilder >> presenterAt: aKey [
	^ (fieldPresenters detect: [ :assoc | assoc key = aKey ] ifNone: [ nil ]) ifNotNil: [ :assoc | assoc value ]
]

{ #category : 'creation' }
DynamicFormBuilder >> radioGroup: aKey label: aLabel items: itemsList columns: columnCount frame: aBoolean [

	| presenter |
	presenter := RadioGroupPresenter new.
	presenter
		items: itemsList;
		сolumnCount: columnCount;
		showTitle: false.
	aBoolean ifTrue: [ presenter showFrame: true ].
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'accessing' }
DynamicFormBuilder >> showButtons [

	isHideButtons := false.
	self defaultLayout
]

{ #category : 'accessing' }
DynamicFormBuilder >> showHeader [

	isHideHeader := false.
	self defaultLayout
]

{ #category : 'accessing' }
DynamicFormBuilder >> style: arg1 [

	formStyle := arg1.
	(fieldPresenters notNil and: [ fieldPresenters notEmpty ]) ifTrue: [
		self applyStyleToAllPresenters ]
]

{ #category : 'accessing' }
DynamicFormBuilder >> submitButtonLabel: arg1 [

	submitButton label: arg1
]

{ #category : 'creation' }
DynamicFormBuilder >> textField: aKey label: aLabel placeholder: aPlaceholder rules: validationRules [

	| presenter |
	presenter := TextInputPresenter new.
	presenter placeholder: aPlaceholder.
	validationRules ifNotNil: [ presenter addValidationRules: validationRules].
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'creation' }
DynamicFormBuilder >> timePicker: aKey label: aLabel [

	| presenter |
	presenter := TimePickerPresenter new.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'accessing' }
DynamicFormBuilder >> topPresenter: arg1 [

	customTopPresenter := arg1
]

{ #category : 'validation' }
DynamicFormBuilder >> validateFields [

	fieldPresenters do: [ :arg1 |
			| tmp1 |
			tmp1 := arg1 value.
			(tmp1 isKindOf: TextInputPresenter) ifTrue: [
					tmp1 validate.
					tmp1 isValid ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : 'accessing' }
DynamicFormBuilder >> values [

	formData := Dictionary new.
	fieldPresenters do: [ :arg1 |
			| tmp1 tmp2 tmp3 |
			tmp1 := arg1 key.
			tmp2 := arg1 value.
			tmp3 := (tmp2 class >> #text) isSymbol
				        ifTrue: [ tmp2 text ]
				        ifFalse: [
						        (tmp2 class >> #selectedItem) isSymbol
							        ifTrue: [ tmp2 selectedItem ]
							        ifFalse: nil ].
			formData at: tmp1 put: tmp3 ].
	^ formData
]
