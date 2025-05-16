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
		'isHideButtons',
		'width',
		'height'
	],
	#category : 'SpecComponentsLibrary-AdvancedComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'AdvancedComponents'
}

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> applyButtonStyle: arg1 [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 |
	(arg1 isKindOf: ButtonPresenter) ifFalse: [ ^ self ].
	tmp3 := tmp1 := formStyle labelFontSize.
	tmp3 ifNotNil: [ arg1 fontSize: tmp1 ].
	tmp4 := tmp1 := formStyle fontFamily.
	tmp4 ifNotNil: [ arg1 fontFamily: tmp1 ].
	tmp5 := tmp1 := formStyle isLabelBold.
	tmp5 ifNotNil: [ arg1 bold ].
	tmp6 := tmp1 := formStyle isLabelItalic.
	tmp6 ifNotNil: [ arg1 italic ].
	tmp7 := tmp1 := formStyle buttonWidth.
	tmp7 ifNotNil: [ arg1 width: tmp1 ].
	tmp8 := tmp2 := formStyle buttonHeight.
	tmp8 ifNotNil: [ arg1 height: tmp2 ].
	tmp9 := tmp2 := formStyle buttonBackground.
	tmp9 ifNotNil: [ arg1 backgroundColor: tmp2 ]
]

{ #category : 'style' }
DynamicFormBuilder >> applyInputStyleTo: arg1 [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 |
	(arg1 isKindOf: TextInputPresenter) ifFalse: [ ^ self ].
	tmp3 := tmp1 := formStyle inputFontSize.
	tmp3 ifNotNil: [ arg1 fontSize: tmp1 ].
	tmp4 := tmp2 := formStyle inputBackground.
	tmp4 ifNotNil: [ arg1 backgroundColor: tmp2 ].
	tmp5 := tmp1 := formStyle inputWidth.
	tmp5 ifNotNil: [ arg1 width: tmp1 ].
	tmp6 := tmp2 := formStyle inputHeight.
	tmp6 ifNotNil: [ arg1 height: tmp2 ].
	tmp7 := tmp1 := formStyle inputBorderWidth.
	tmp7 ifNotNil: [ arg1 borderWidth: tmp1 ].
	tmp8 := tmp2 := formStyle inputBorderColor.
	tmp8 ifNotNil: [ arg1 borderColor: tmp2 ]
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
	tmp5 ifNotNil: [ arg1 bold ].
	tmp6 := tmp1 := formStyle isLabelItalic.
	tmp6 ifNotNil: [ arg1 italic ].
	tmp7 := tmp2 := formStyle labelColor.
	tmp7 ifNotNil: [ arg1 color: tmp2 ]
]

{ #category : 'style' }
DynamicFormBuilder >> applyStyleToAllPresenters [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 |
	formStyle ifNil: [ ^ self ].
	formStyle.
	tmp1 := fieldPresenters copy.
	headerLabel ifNotNil: [
			tmp4 := tmp2 := formStyle headerFontSize.
			tmp4 ifNotNil: [ headerLabel fontSize: tmp2 ].
			tmp5 := tmp2 := formStyle fontFamily.
			tmp5 ifNotNil: [ headerLabel fontFamily: tmp2 ].
			tmp6 := tmp2 := formStyle isHeaderBold.
			tmp6 ifNotNil: [ headerLabel bold ].
			tmp7 := tmp2 := formStyle isHeaderItalic.
			tmp7 ifNotNil: [ headerLabel italic ].
			tmp8 := tmp3 := formStyle headerColor.
			tmp8 ifNotNil: [ headerLabel color: tmp3 ] ].
	submitButton ifNotNil: [ tmp1 add: #__submit__ -> submitButton ].
	backButton ifNotNil: [ tmp1 add: #__back__ -> backButton ].
	tmp1 do: [ :arg1 |
			| tmp9 |
			tmp9 := arg1 value.
			self
				applyLabelStyle: tmp9;
				applyInputStyleTo: tmp9;
				applyButtonStyle: tmp9 ]
]

{ #category : 'accessing' }
DynamicFormBuilder >> backButtonLabel: arg1 [

	backButton label: arg1
]

{ #category : 'creation' }
DynamicFormBuilder >> checkbox: arg1 label: arg2 text: arg3 [

	| tmp1 |
	tmp1 := CheckboxPresenter new.
	tmp1 mainPresenter label: arg3.
	fieldPresenters add: arg1 -> tmp1.
	fieldLabels at: arg1 put: arg2
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

	| tmp1 |
	tmp1 := Dictionary new.
	fieldPresenters do: [ :arg1 |
			| tmp2 tmp3 tmp4 tmp5 |
			tmp2 := arg1 key.
			tmp3 := arg1 value.
			tmp4 := (tmp3 isKindOf: TextInputPresenter)
				        ifTrue: [ tmp3 text ]
				        ifFalse: [
						        (tmp3 isKindOf: SpDropListPresenter)
							        ifTrue: [ tmp3 selectedItem ]
							        ifFalse: [
									        (tmp3 isKindOf: ComboBoxPresenter)
										        ifTrue: [ tmp3 selectedItem ]
										        ifFalse: [
												        (tmp3 isKindOf: MultiSelectComboBoxPresenter)
													        ifTrue: [ tmp3 selectedItems ]
													        ifFalse: [
															        (tmp3 isKindOf: SpDatePresenter)
																        ifTrue: [ tmp3 date ]
																        ifFalse: [
																		        (tmp3 isKindOf: TimePickerPresenter)
																			        ifTrue: [
																					        tmp5 := Dictionary new.
																					        tmp5
																						        at: #hour put: tmp3 hour;
																						        at: #minutes put: tmp3 minutes;
																						        yourself ]
																			        ifFalse: [
																					        (tmp3 isKindOf: CheckboxPresenter)
																						        ifTrue: [ tmp3 mainPresenter state ]
																						        ifFalse: [
																								        (tmp3 isKindOf: RadioGroupPresenter)
																									        ifTrue: [ tmp3 itemSelected ]
																									        ifFalse: [
																										        (tmp3 isKindOf:
																											         CheckboxGroupPresenter) ifTrue: [
																											        tmp3 selectedItems ] ] ] ] ] ] ] ] ].
			tmp1 at: tmp2 put: tmp4 ].
	formData := tmp1.
	^ tmp1
]

{ #category : 'creation' }
DynamicFormBuilder >> comboBox: arg1 label: arg2 items: arg3 [

	| tmp1 |
	tmp1 := ComboBoxPresenter new.
	tmp1 items: arg3.
	fieldPresenters add: arg1 -> tmp1.
	fieldLabels at: arg1 put: arg2
]

{ #category : 'initialization' }
DynamicFormBuilder >> connectPresenters [

	submitButton onClick: [
			((onSubmitAction isNil or: [ self validateFields not ]) or: [
				 self collectValues isNil ]) ifFalse: [
				onSubmitAction value: self collectValues ] ].
	backButton onClick: [
	onBackAction ifNotNil: [ onBackAction value ].
]

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

	| tmp1 tmp2 tmp3 tmp4 tmp6 |
	self applyStyleToAllPresenters.
	tmp1 := SpBoxLayout newVertical spacing: 10.
	tmp2 := SpBoxLayout newVertical.
	tmp2
		hAlignCenter;
		spacing: 5.
	customTopPresenter ifNotNil: [ tmp2 add: customTopPresenter ].
	isHideHeader ifFalse: [ tmp2 add: headerLabel expand: false ].
	tmp1 add: tmp2 expand: false.
	tmp3 := SpGridLayout new.
	tmp3
		beColumnNotHomogeneous;
		beRowNotHomogeneous.
	tmp6 := 1.
	fieldPresenters do: [ :arg1 |
			| tmp7 tmp8 tmp9 |
			tmp7 := arg1 key.
			tmp8 := arg1 value.
			tmp9 := LabelPresenter new text:
				        (fieldLabels at: tmp7 ifAbsent: '').
			formStyle ifNotNil: [ self applyLabelStyle: tmp9 ].
			tmp3
				add: tmp9 atPoint: 1 @ tmp6;
				add: tmp8 atPoint: 2 @ tmp6 span: 2 @ 1.
			tmp6 := tmp6 + 1 ].
	tmp1 add: tmp3 withConstraints: [ :arg2 |
			height
				ifNil: [ arg2 height: fieldPresenters size * 40 ]
				ifNotNil: [ arg2 height: height ] ].
	isHideButtons ifFalse: [
			tmp4 := SpBoxLayout newLeftToRight.
			tmp4
				hAlignCenter;
				spacing: 20;
				add: backButton expand: false;
				add: submitButton expand: false.
			tmp1 add: tmp4 expand: false ].
	^ tmp1 yourself
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
DynamicFormBuilder >> height: aHeight [
   height := aHeight 
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
DynamicFormBuilder >> textField: arg1 label: arg2 placeholder: arg3 rules: arg4 [

	| tmp1 |
	tmp1 := TextInputPresenter new.
	tmp1 placeholder: arg3.
	arg4 ifNotNil: [
			tmp1
				isValidationField: true;
				addValidationRules: arg4 ].
	fieldPresenters add: arg1 -> tmp1.
	fieldLabels at: arg1 put: arg2
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
					tmp1 isValid ifFalse: [ ^ false ] ].
			(tmp1 isKindOf: ComboBoxPresenter) ifTrue: [
				tmp1 selectedIndex = 0 ifTrue: [ ^ false ] ] ].
	^ true
]

{ #category : 'accessing' }
DynamicFormBuilder >> values [

	^ formData
]

{ #category : 'accessing' }
DynamicFormBuilder >> width: arg1 [

	width := arg1
]
