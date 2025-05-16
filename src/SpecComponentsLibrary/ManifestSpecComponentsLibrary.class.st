"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestSpecComponentsLibrary',
	#superclass : 'PackageManifest',
	#category : 'SpecComponentsLibrary-Manifest',
	#package : 'SpecComponentsLibrary',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestSpecComponentsLibrary class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#NotificationPresenter #computePositionFor:in: #false)) #'2025-05-13T19:04:06.207+03:00') )
]

{ #category : 'code-critics' }
ManifestSpecComponentsLibrary class >> ruleCascadedNextPutAllsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#EventRegistrationForm #handleSubmit #false)) #'2025-05-13T23:12:50.721+03:00') )
]

{ #category : 'code-critics' }
ManifestSpecComponentsLibrary class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TimePickerDialogPresenter #updateSelectionMarker #false)) #'2025-05-13T18:01:28.43+03:00') #(#(#RGMethodDefinition #(#NotificationPresenter #computePositionFor:in: #false)) #'2025-05-13T19:04:09.077+03:00') )
]

{ #category : 'code-critics' }
ManifestSpecComponentsLibrary class >> ruleReCyclomaticComplexityRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TimePickerDialogPresenter #updateSelectionMarker #false)) #'2025-05-13T18:01:24.905+03:00') )
]

{ #category : 'code-critics' }
ManifestSpecComponentsLibrary class >> ruleTempVarOverridesInstVarRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TimePickerDialogPresenter #updateSelectionMarker #false)) #'2025-05-13T18:01:20.419+03:00') #(#(#RGMethodDefinition #(#NotificationPresenter #computePositionFor:in: #false)) #'2025-05-13T19:04:03.387+03:00') )
]
