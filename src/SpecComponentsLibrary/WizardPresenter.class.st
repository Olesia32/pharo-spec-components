Class {
	#name : 'WizardPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'steps',
		'currentStepIndex',
		'stepHeaderPresenters',
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

    stepHeaderPresenters := StepHeaderPresenter new.

    contentPresenter := SpPresenter new.

    nextButton := ButtonPresenter new label: 'Вперед'; onClick: [ self goToNextStep ].
    backButton := ButtonPresenter new label: 'Назад'; onClick: [ self goToPreviousStep ].

    self updateLayout.
]

{ #category : 'enumerating' }
WizardPresenter >> onFinishDo: aBlock [ 
    
]

{ #category : 'as yet unclassified' }
WizardPresenter >> stepCircleRadius: aNumber [
    stepHeaderPresenters isNil ifTrue: [ ^ self ].
    aNumber isNil ifTrue: [ ^ self ].
    stepHeaderPresenters radius: (aNumber max: 5).
    self updateLayout 
   
]

{ #category : 'as yet unclassified' }
WizardPresenter >> stepCircleTitleColor: aColor [
stepHeaderPresenters titleColor: aColor.
    
]

{ #category : 'accessing' }
WizardPresenter >> steps: aCollection [ 
    |stepTitles|
    steps := aCollection asOrderedCollection.
    stepTitles := steps collect: [ :step | step at: #title ].
    stepHeaderPresenters stepTitles: stepTitles .
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
        add: stepHeaderPresenters withConstraints: [:c | c height: stepHeaderPresenters headerHeight ];
        add: contentPresenter;
        add: buttonBar expand: false;
        yourself).

]

{ #category : 'as yet unclassified' }
WizardPresenter >> updateStepHeader [

	stepHeaderPresenters activeIndex: currentStepIndex 
]

{ #category : 'enumerating' }
WizardPresenter >> whenStepChangedDo: aBlock [ 
    onStepChanged := aBlock.
]
