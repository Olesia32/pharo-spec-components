Class {
	#name : 'LabelPresenter',
	#superclass : 'BasePresenter',
	#instVars : [
		'label'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
LabelPresenter >> bold [
    self setGeneratedStyleProperty: #bold value: true.
]

{ #category : 'accessing' }
LabelPresenter >> color: aColor [

	self setGeneratedStyleProperty: #color value: aColor.
	
]

{ #category : 'as yet unclassified' }
LabelPresenter >> defaultLayout [
   self generateAndApplyStyle.
	^ SpBoxLayout newTopToBottom
		  add: label;
		  yourself
]

{ #category : 'font description' }
LabelPresenter >> fontFamily: aFontFamily [
self setGeneratedStyleProperty: #name value: aFontFamily 
]

{ #category : 'accessing' }
LabelPresenter >> fontSize: aNumber [

	self setGeneratedStyleProperty: #fontSize value: aNumber
]

{ #category : 'as yet unclassified' }
LabelPresenter >> generateAndApplyStyle [
 
   |styleName|
   styleName := super generateAndApplyStyle.
	label addStyle: styleName
]

{ #category : 'initialization' }
LabelPresenter >> initialize [

	super initialize
]

{ #category : 'initialization' }
LabelPresenter >> initializePresenters [

	label := SpLabelPresenter new.
	self focusOrder add: label
]

{ #category : 'accessing' }
LabelPresenter >> italic [
self setGeneratedStyleProperty: #italic value: true
]

{ #category : 'accessing' }
LabelPresenter >> text [
    ^ label label.
]

{ #category : 'accessing' }
LabelPresenter >> text: aString [
    label label: aString.
]
