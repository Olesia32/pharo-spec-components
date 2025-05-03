Class {
	#name : 'DynamicFormBuilder',
	#superclass : 'BasePresenter',
	#instVars : [
		'fields',
		'fieldPresenters',
		'formData',
		'headerText',
		'customTopPresenter',
		'submitButton',
		'backButton',
		'headerLabel',
		'submitLabel',
		'backLabel',
		'onSubmitAction',
		'onBackAction',
		'formStyle'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> applyLabelStyle: aLabel [

	(aLabel isKindOf: LabelPresenter) ifFalse: [ ^ self ].
	formStyle labelFontSize ifNotNil: [ :f | aLabel fontSize: f ].
	formStyle fontFamily ifNotNil: [ :f | aLabel fontFamily: f ].
	formStyle isLabelBold ifNotNil: [ :f | aLabel bold: f ].
	formStyle isLabelItalic ifNotNil: [ :f | aLabel italic: f ].
	formStyle labelColor ifNotNil: [ :c | aLabel color: c ]
]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> applyStyleToAllPresenters [

	| allPresenters |
	formStyle ifNil: [ ^ self ].
	allPresenters := fieldPresenters copy.

	headerLabel ifNotNil: [ allPresenters add: #__title__ -> headerLabel ].
	submitButton ifNotNil: [
		allPresenters add: #__submit__ -> submitButton ].
	backButton ifNotNil: [ allPresenters add: #__back__ -> backButton ].
	allPresenters do: [ :assoc |
			| presenter |
			presenter := assoc value.
			self applyLabelStyle: presenter.
			assoc key = #__title__ ifTrue: [
					formStyle headerFontSize ifNotNil: [ :f | presenter fontSize: f ].
					formStyle fontFamily ifNotNil: [ :f | presenter fontFamily: f ].
					formStyle isHeaderBold ifNotNil: [ :f | presenter bold: f ].
					formStyle isHeaderItalic ifNotNil: [ :f | presenter italic: f ].
					formStyle headerColor ifNotNil: [ :c | presenter color: c ] ].

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
                                (presenter isKindOf: SpDatePresenter)
                                    ifTrue: [ presenter date ]
                                    ifFalse: [
                                        (presenter isKindOf: SpCheckBoxPresenter)
                                            ifTrue: [ presenter state ]
                                            ifFalse: [ nil ]
                                    ]
                            ]
                    ]
            ].

        result at: key put: value.
    ].

    ^ result
]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> connectPresenters [

	submitButton onClick: [
        (onSubmitAction isNil or: [ self collectValues isNil ]) ifTrue: [ ^ self ].
        (self validateFields) ifTrue: [
            onSubmitAction value: self collectValues
        ]].
	backButton onClick: [
		onBackAction ifNotNil: [ onBackAction value: self ] ]
]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> createPresenterFromSpec: arg1 [ 
	| type label presenter |

	type := arg1 at: #type.
	label := arg1 at: #label ifAbsent: ''.

	presenter := type = 'label'
		ifTrue: [ LabelPresenter new text: label ]
		ifFalse: [
			type = 'text'
				ifTrue: [ TextInputPresenter new ]
				ifFalse: [
					type = 'dropdown'
						ifTrue: [ SpDropListPresenter new ]
						ifFalse: [
							type = 'combobox'
								ifTrue: [ ComboBoxPresenter new ]
								ifFalse: [
									type = 'checkbox'
										ifTrue: [ SpCheckBoxPresenter new ]
										ifFalse: [
											type = 'radiobutton'
												ifTrue: [ SpRadioButtonPresenter new ]
												ifFalse: [
													type = 'date'
														ifTrue: [ SpDatePresenter new ]
														ifFalse: [
															LabelPresenter new text: 'Unsupported type: ', type
														]
												]
										]
								]
						]
				]
		].

	"Присвоєння властивостей"
	(presenter respondsTo: #label:) ifTrue: [ presenter label: label ].
	(arg1 includesKey: #placeholder) ifTrue: [
		(presenter respondsTo: #placeholder:) ifTrue: [
			presenter placeholder: (arg1 at: #placeholder)
		]
	].
	(arg1 includesKey: #items) ifTrue: [
		(presenter respondsTo: #items:) ifTrue: [
			presenter items: (arg1 at: #items)
		]
	].
	(arg1 includesKey: #validationRules) ifTrue: [
			(presenter respondsTo: #addValidationRule:message:) ifTrue: [
				(arg1 at: #validationRules) applyTo: presenter ] ].


	^ presenter

]

{ #category : 'as yet unclassified' }
DynamicFormBuilder >> defaultLayout [

	| tmp1 tmp2 tmp3 tmp5 tmp6 tmp10 |
	self applyStyleToAllPresenters.
	tmp1 := SpBoxLayout newVertical.
	tmp1 spacing: 0.
	tmp5 := SpBoxLayout newVertical.
	tmp5
		hAlignCenter;
		spacing: 5.
	customTopPresenter ifNotNil: [ tmp5 add: customTopPresenter ].
	tmp5 add: headerLabel.
	tmp1 add: tmp5.
	tmp2 := SpGridLayout new.
	tmp2 beColumnNotHomogeneous.
	tmp10 := 1.
	fieldPresenters do: [ :arg1 |
			| tmp11 tmp12 tmp13 |
			tmp13 := fields detect: [ :arg2 | (arg2 at: #key) = arg1 key ].
			tmp11 := LabelPresenter new text: (tmp13 at: #label ifAbsent: '').
			self applyLabelStyle: tmp11.
			tmp12 := arg1 value.
			tmp2
				add: tmp11 atPoint: 1 @ tmp10;
				add: tmp12 atPoint: 2 @ tmp10 span: 2 @ 1.
			tmp10 := tmp10 + 1 ].
	tmp6 := fieldPresenters size.
	tmp1 add: tmp2 withConstraints: [ :arg3 |
			arg3
				height: tmp6 * 40;
				expand: false ].
	tmp3 := SpBoxLayout newLeftToRight.
	tmp3
		hAlignCenter;
		spacing: 20.
	tmp3 add: submitButton yourself.
	tmp3 add: backButton yourself.
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
DynamicFormBuilder >> style: aStyle [ 
    formStyle := aStyle.
    (fieldPresenters notNil and: [ fieldPresenters notEmpty ]) ifTrue: [
        self applyStyleToAllPresenters
    ].
    
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
    fieldPresenters do: [ :assoc |
        | presenter |
        presenter := assoc value.

        (presenter isKindOf: TextInputPresenter) ifTrue: [
            presenter validate.
            presenter isValid ifFalse: [ ^ false ].
        ].
    ].
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
