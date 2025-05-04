Class {
	#name : 'DynamicFormBuilder',
	#superclass : 'SpPresenter',
	#instVars : [
		'fields',
		'fieldPresenters',
		'formData',
		'customTopPresenter',
		'submitButton',
		'backButton',
		'headerLabel',
		'onSubmitAction',
		'onBackAction',
		'formStyle'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
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
			self applyLabelStyle: presenter.
			(presenter isKindOf: TextInputPresenter) ifTrue: [
					formStyle inputFontSize ifNotNil: [ :f | presenter fontSize: f ].
					formStyle inputBackground ifNotNil: [ :c |
						presenter backgroundColor: c ].
					formStyle inputWidth ifNotNil: [ :f | presenter width: f ].
					formStyle inputHeight ifNotNil: [ :c | presenter height: c ].
					formStyle inputBorderWidth ifNotNil: [ :f |
						presenter borderWidth: f ].
					formStyle inputBorderColor ifNotNil: [ :c |
						presenter borderColor: c ] ].

			(presenter isKindOf: ButtonPresenter) ifTrue: [
					formStyle labelFontSize ifNotNil: [ :f | presenter fontSize: f ].
					formStyle fontFamily ifNotNil: [ :f | presenter fontFamily: f ].
					formStyle isLabelBold ifNotNil: [ :f | presenter bold: f ].
					formStyle isLabelItalic ifNotNil: [ :f | presenter italic: f ].
					formStyle labelColor ifNotNil: [ :c | presenter color: c ].
					formStyle buttonWidth ifNotNil: [ :f | presenter width: f ].
					formStyle buttonHeight ifNotNil: [ :c | presenter height: c ] ] ]
]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> backButtonLabel: arg1 [

	backButton label: arg1
]

{ #category : 'accessing' }
DynamicFormBuilder >> collectValues [

	| tmp1 |
	tmp1 := Dictionary new.
	fieldPresenters do: [ :arg1 |
			| tmp2 tmp3 tmp4 |
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
												        (tmp3 isKindOf: SpDatePresenter)
													        ifTrue: [ tmp3 date ]
													        ifFalse: [
													        (tmp3 isKindOf: SpCheckBoxPresenter) ifTrue: [
														        tmp3 state ] ] ] ] ].
			tmp1 at: tmp2 put: tmp4 ].
	^ tmp1
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> createPresenterFromSpec: arg1 [

	| tmp1 tmp2 tmp3 |
	tmp1 := arg1 at: #type.
	tmp2 := arg1 at: #label ifAbsent: ''.
	tmp3 := tmp1 = 'label'
		        ifTrue: [ LabelPresenter new text: tmp2 ]
		        ifFalse: [
				        tmp1 = 'text'
					        ifTrue: [ TextInputPresenter new ]
					        ifFalse: [
							        tmp1 = 'dropdown'
								        ifTrue: [ SpDropListPresenter new ]
								        ifFalse: [
										        tmp1 = 'combobox'
											        ifTrue: [ ComboBoxPresenter new ]
											        ifFalse: [
													        tmp1 = 'checkbox'
														        ifTrue: [ SpCheckBoxPresenter new ]
														        ifFalse: [
																        tmp1 = 'radiobutton'
																	        ifTrue: [ SpRadioButtonPresenter new ]
																	        ifFalse: [
																			        tmp1 = 'date'
																				        ifTrue: [ SpDatePresenter new ]
																				        ifFalse: [
																				        LabelPresenter new text:
																					        'Unsupported type: ' , tmp1 ] ] ] ] ] ] ].
	(tmp3 respondsTo: #label:) ifTrue: [ tmp3 label: tmp2 ].
	(arg1 includesKey: #placeholder) ifTrue: [
			(tmp3 respondsTo: #placeholder:) ifTrue: [
				tmp3 placeholder: (arg1 at: #placeholder) ] ].
	(arg1 includesKey: #items) ifTrue: [
		(tmp3 respondsTo: #items:) ifTrue: [ tmp3 items: (arg1 at: #items) ] ].
	(arg1 includesKey: #validationRules) ifTrue: [
			(tmp3 respondsTo: #addValidationRule:message:) ifTrue: [
				(arg1 at: #validationRules) applyTo: tmp3 ] ].
	^ tmp3
]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> defaultLayout [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp7 |
	self applyStyleToAllPresenters.
	tmp1 := SpBoxLayout newVertical.
	tmp1 spacing: 0.
	tmp4 := SpBoxLayout newVertical.
	tmp4
		hAlignCenter;
		spacing: 5.
	customTopPresenter ifNotNil: [ tmp4 add: customTopPresenter ].
	tmp4 add: headerLabel.
	tmp1 add: tmp4.
	tmp2 := SpGridLayout new.
	tmp2 beColumnNotHomogeneous.
	tmp7 := 1.
	fieldPresenters do: [ :arg1 |
			| tmp8 tmp9 tmp10 |
			tmp10 := fields detect: [ :arg2 | (arg2 at: #key) = arg1 key ].
			tmp8 := LabelPresenter new text: (tmp10 at: #label ifAbsent: '').
			self applyLabelStyle: tmp8.
			tmp9 := arg1 value.
			tmp2
				add: tmp8 atPoint: 1 @ tmp7;
				add: tmp9 atPoint: 2 @ tmp7 span: 2 @ 1.
			tmp7 := tmp7 + 1 ].
	tmp5 := fieldPresenters size.
	tmp1 add: tmp2 withConstraints: [ :arg3 |
			arg3
				height: tmp5 * 40;
				expand: false ].
	tmp3 := SpBoxLayout newLeftToRight.
	tmp3
		hAlignCenter;
		spacing: 20;
		add: submitButton yourself;
		add: backButton yourself.
	tmp1 add: tmp3 expand: false.
	^ tmp1 yourself
]

{ #category : 'accessing' }
DynamicFormBuilder >> fields: arg1 [

	fields := arg1.
	fieldPresenters addAll: (fields collect: [ :arg2 |
				 | tmp1 tmp2 |
				 tmp2 := arg2 at: #key.
				 tmp1 := self createPresenterFromSpec: arg2.
				 tmp2 -> tmp1 ])
]

{ #category : 'accessing' }
DynamicFormBuilder >> header: arg1 [

	headerLabel text: arg1
]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> initializePresenters [

	fields ifNil: [ fields := #(  ) ] ifNotNil: [ fields ].
	fieldPresenters := OrderedCollection new.
	formData := Dictionary new.
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

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> onBack: arg1 [

	onBackAction := arg1
]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> onSubmit: arg1 [

	onSubmitAction := arg1
]

{ #category : 'accessing' }
DynamicFormBuilder >> style: arg1 [

	formStyle := arg1.
	(fieldPresenters notNil and: [ fieldPresenters notEmpty ]) ifTrue: [
		self applyStyleToAllPresenters ]
]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> submitButtonLabel: arg1 [

	submitButton label: arg1
]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> topPresenter: arg1 [

	customTopPresenter := arg1
]

{ #category : 'as yet unclassified' }
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
