"
I am a high-level presenter for building dynamic forms in Spec.  
I support automatic construction of labeled input fields using a wide variety of built-in presenters including:
`TextInputPresenter`, `CheckboxPresenter`, `CheckboxGroupPresenter`, `RadioGroupPresenter`, `SpDatePresenter`, `TimePickerPresenter`, `SpDropListPresenter`, `ComboBoxPresenter`, and `MultiSelectComboBoxPresenter`.

I also support:
- Form-wide styling via `FormStyle`
- Submit/Back buttons (which can be shown or hidden)
- Optional header with custom styling
- Collection of all field values as a dictionary
- Input validation and button-driven event callbacks

### Instance Variables

- _fields_: an `Array` or `Collection` — optional list of presenter specifications for auto-creation  
- _fieldLabels_: a `Dictionary` — maps field keys to label texts  
- _fieldPresenters_: an `OrderedCollection` — contains key–presenter pairs  
- _formData_: a `Dictionary` — stores collected values from the form  
- _customTopPresenter_: a `SpPresenter` — optional presenter displayed above the form  
- _submitButton_, _backButton_: `ButtonPresenter`s — buttons shown at the bottom for submission and navigation  
- _headerLabel_: a `LabelPresenter` — optional header text displayed at the top  
- _onSubmitAction_, _onBackAction_: `BlockClosure`s — callbacks for button events  
- _formStyle_: a `FormStyle` — optional object controlling visual appearance of fields  
- _isHideHeader_, _isHideButtons_: `Boolean`s — control visibility of header and buttons  
- _height_: `Integer — optional size constraint for the form area

### Public API

- `DynamicFormBuilder>>#textField:label:placeholder:rules:` — adds a text input with validation
- `DynamicFormBuilder>>#checkbox:label:text:` — adds a single checkbox
- `DynamicFormBuilder>>#checkboxGroup:label:items:columns:frame:` — adds a checkbox group with layout options
- `DynamicFormBuilder>>#radioGroup:label:items:columns:frame:` — adds a radio button group
- `DynamicFormBuilder>>#dropList:label:items:` — adds a drop-down list
- `DynamicFormBuilder>>#comboBox:label:items:` — adds a filterable combobox
- `DynamicFormBuilder>>#multiComboBox:label:items:` — adds a multi-selection combobox
- `DynamicFormBuilder>>#datePicker:label:` — adds a date picker
- `DynamicFormBuilder>>#timePicker:label:` — adds a time picker
- `DynamicFormBuilder>>#style:` — applies a `FormStyle` to all components
- `DynamicFormBuilder>>#collectValues` — collects and returns a dictionary of all current field values
- `DynamicFormBuilder>>#validateFields` — validates fields and returns `true` or `false`
- `DynamicFormBuilder>>#onSubmit:` / `DynamicFormBuilder>>#onBack:` — sets callbacks for submit and back buttons
- `DynamicFormBuilder>>#showHeader`, `DynamicFormBuilder>>#hideHeader`, `DynamicFormBuilder>>#showButtons`, `DynamicFormBuilder>>#hideButtons` — toggles UI elements
- `DynamicFormBuilder>>#header:` — sets the form title
- `DynamicFormBuilder>>#submitButtonLabel:` / `DynamicFormBuilder>>#backButtonLabel:` — sets button text
- `DynamicFormBuilder>>#topPresenter:` — sets a custom presenter above the form

### Usage

To create a form programmatically:

```smalltalk
| form |
form := DynamicFormBuilder new.
form textField: #name label: 'Your Name' placeholder: 'Enter full name' rules: { ValidationRules nonEmpty }.
form checkbox: #terms label: 'Terms' text: 'I agree to the terms'.
form onSubmit: [ Transcript show: form collectValues printString ].
form open.


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
		'height'
	],
	#category : 'SpecComponentsLibrary-AdvancedComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'AdvancedComponents'
}

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> applyButtonStyle: arg1 [
"Applies style properties (font, size, background, bold, italic) from the current FormStyle to a ButtonPresenter."
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
"Applies style properties (font, background, border, size) to a TextInputPresenter, using values from FormStyle."
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
"Applies label styling (font size, bold, italic, color) to a LabelPresenter using values from FormStyle."
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
"Iterates through all presenters in the form and applies the appropriate style (label, input, or button) depending on the type.
Also applies header styling if present."
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
"Sets the label text for the back button."
	backButton label: arg1
]

{ #category : 'creation' }
DynamicFormBuilder >> checkbox: arg1 label: arg2 text: arg3 [
"Adds a CheckboxPresenter with a given label and inline text.
Stores it in fieldPresenters under the provided key."
	| tmp1 |
	tmp1 := CheckboxPresenter new.
	tmp1 mainPresenter label: arg3.
	fieldPresenters add: arg1 -> tmp1.
	fieldLabels at: arg1 put: arg2
]

{ #category : 'creation' }
DynamicFormBuilder >> checkboxGroup: aKey label: aLabel items: itemsList columns: columnCount frame: aBoolean [
"Adds a CheckboxGroupPresenter with provided items and layout settings.
Optional frame and label are applied."
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
"Collects the current values of all form fields into a dictionary.
Supports multiple presenter types by using presenter-specific accessors (e.g., text, selectedItem, selectedItems, date, hour/minute, etc.)."
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
"Adds a ComboBoxPresenter initialized with the given item list and label."
	| tmp1 |
	tmp1 := ComboBoxPresenter new.
	tmp1 items: arg3.
	fieldPresenters add: arg1 -> tmp1.
	fieldLabels at: arg1 put: arg2
]

{ #category : 'initialization' }
DynamicFormBuilder >> connectPresenters [
"Connects the click events of the back and submit buttons to the defined callbacks.
Triggers validation and value collection before submission."
	submitButton onClick: [
			((onSubmitAction isNil or: [ self validateFields not ]) or: [
				 self collectValues isNil ]) ifFalse: [
				onSubmitAction value: self collectValues ] ].
	backButton onClick: [ onBackAction ifNotNil: [ onBackAction value ] ]
]

{ #category : 'creation' }
DynamicFormBuilder >> datePicker: aKey label: aLabel [
"Adds a SpDatePresenter to the form under the specified key and label."
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
"Adds a SpDropListPresenter to the form with the given label and items."
	| presenter |
	presenter := SpDropListPresenter new.
	presenter items: itemsList.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'accessing' }
DynamicFormBuilder >> header: arg1 [
"Sets the text for the form header label."
	headerLabel text: arg1
]

{ #category : 'accessing' }
DynamicFormBuilder >> height: aHeight [
"Sets the total height constraint of the form content area."
	height := aHeight
]

{ #category : 'accessing' }
DynamicFormBuilder >> hideButtons [
"Hides the submit/back buttons and refreshes the layout."
	isHideButtons := true.
	self defaultLayout
]

{ #category : 'accessing' }
DynamicFormBuilder >> hideHeader [
"Hides the header label and refreshes the layout."
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
"Adds a MultiSelectComboBoxPresenter with the specified label and items."
	| presenter |
	presenter := MultiSelectComboBoxPresenter new.
	presenter items: itemsList.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'events' }
DynamicFormBuilder >> onBack: arg1 [
"Sets the callback to execute when the back button is clicked."
	onBackAction := arg1
]

{ #category : 'events' }
DynamicFormBuilder >> onSubmit: arg1 [
"Sets the callback to execute when the submit button is clicked."
	onSubmitAction := arg1
]

{ #category : 'accessing' }
DynamicFormBuilder >> presenterAt: aKey [
"Returns the presenter associated with the given field key (or nil if not found)."
	^ (fieldPresenters
		   detect: [ :assoc | assoc key = aKey ]
		   ifNone: [ nil ]) ifNotNil: [ :assoc | assoc value ]
]

{ #category : 'creation' }
DynamicFormBuilder >> radioGroup: aKey label: aLabel items: itemsList columns: columnCount frame: aBoolean [
"Adds a RadioGroupPresenter with provided items, optional frame, and multi-column layout."
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
"Shows the submit/back buttons and refreshes the layout."
	isHideButtons := false.
	self defaultLayout
]

{ #category : 'accessing' }
DynamicFormBuilder >> showHeader [
"Shows the header label and refreshes the layout."
	isHideHeader := false.
	self defaultLayout
]

{ #category : 'accessing' }
DynamicFormBuilder >> style: arg1 [
"Assigns a FormStyle to the form.
Immediately applies the style to all presenters if they already exist."
	formStyle := arg1.
	(fieldPresenters notNil and: [ fieldPresenters notEmpty ]) ifTrue: [
		self applyStyleToAllPresenters ]
]

{ #category : 'accessing' }
DynamicFormBuilder >> submitButtonLabel: arg1 [
"Sets the label text for the submit button."
	submitButton label: arg1
]

{ #category : 'creation' }
DynamicFormBuilder >> textField: arg1 label: arg2 placeholder: arg3 rules: arg4 [
"Adds a TextInputPresenter with optional placeholder and validation rules.
Adds it to the form under the given key."
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
"Adds a TimePickerPresenter to the form with the specified label."
	| presenter |
	presenter := TimePickerPresenter new.
	fieldPresenters add: aKey -> presenter.
	fieldLabels at: aKey put: aLabel
]

{ #category : 'accessing' }
DynamicFormBuilder >> topPresenter: arg1 [
"Adds a custom presenter to be shown above the form (e.g., icon, instruction, image, etc.)."
	customTopPresenter := arg1
]

{ #category : 'validation' }
DynamicFormBuilder >> validateFields [
"Validates all fields in the form.
Checks TextInputPresenter for validation status and ComboBoxPresenter for empty selection."
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
"Returns the previously collected values (if collectValues was called) from formData."
	^ formData
]
