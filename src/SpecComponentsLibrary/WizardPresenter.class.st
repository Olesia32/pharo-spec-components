Class {
	#name : 'WizardPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'steps',
		'currentStepIndex',
		'stepHeaderPresenters',
		'stepHeaderBar',
		'contentPresenter',
		'nextButton',
		'backButton',
		'onStepChanged'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'as yet unclassified' }
WizardPresenter >> goToNextStep [ 
    self goToStep: currentStepIndex + 1.
]

{ #category : 'as yet unclassified' }
WizardPresenter >> goToPreviousStep [ 
    self goToStep: currentStepIndex - 1.
]

{ #category : 'as yet unclassified' }
WizardPresenter >> goToStep: aNumber [

	(aNumber between: 1 and: steps size) ifFalse: [ ^ self ].
	currentStepIndex := aNumber.
	contentPresenter layout: ((steps at: currentStepIndex) at: #content).
	self updateButtonStates.
	self updateStepHeader.
	onStepChanged ifNotNil: [ onStepChanged value: currentStepIndex ]
]

{ #category : 'initialization' }
WizardPresenter >> initializePresenters [ 
    steps := OrderedCollection new.
    currentStepIndex := 1.

    stepHeaderBar := SpBoxLayout newLeftToRight spacing: 20.

    contentPresenter := SpPresenter new.

    nextButton := ButtonPresenter new label: 'Вперед'; onClick: [ self goToNextStep ].
    backButton := ButtonPresenter new label: 'Назад'; onClick: [ self goToPreviousStep ].

    self updateLayout.
]

{ #category : 'enumerating' }
WizardPresenter >> onFinishDo: aBlock [ 
    
]

{ #category : 'accessing' }
WizardPresenter >> steps: aCollection [ 
    steps := aCollection asOrderedCollection.
    self goToStep: 1.
]

{ #category : 'accessing' }
WizardPresenter >> updateButtonStates [ 
    backButton mainPresenter enabled: currentStepIndex > 1.
    (currentStepIndex = steps size) ifTrue: [ nextButton label: 'Завершити' ] ifFalse: [ nextButton label: 'Вперед' ]
]

{ #category : 'private' }
WizardPresenter >> updateLayout [ 
    | buttonBar |
    buttonBar := SpBoxLayout newLeftToRight 
        spacing: 10;
        add: backButton;
        add: nextButton;
        yourself.

    self layout: (SpBoxLayout newTopToBottom
        spacing: 10;
        add: stepHeaderBar expand: false;
        add: contentPresenter;
        add: buttonBar expand: false;
        yourself).

]

{ #category : 'as yet unclassified' }
WizardPresenter >> updateStepHeader [

	| start end visibleSteps |
	stepHeaderBar removeAll.

	start := currentStepIndex - 1 max: 1.
	end := currentStepIndex + 1 min: steps size.

	visibleSteps := (start to: end) collect: [ :i |
			                | labelPresenter |
			                labelPresenter := LabelPresenter new.
			                labelPresenter text:
				                (i asString , '. ' , ((steps at: i) at: #title)).
			                i = currentStepIndex
				                ifTrue: [
						                labelPresenter
							                bold;
							                color: '#red' ]
				                ifFalse: [ labelPresenter color: '#gray' ].
			                labelPresenter ].
	visibleSteps do: [ :stepLabel | stepHeaderBar add: stepLabel ].
]

{ #category : 'enumerating' }
WizardPresenter >> whenStepChangedDo: aBlock [ 
    onStepChanged := aBlock.
]
