Class {
	#name : 'Mutator',
	#superclass : 'Object',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
Mutator >> mutate: aPath [

	| path | 
	path := RAPath new.
	path pathConstraints: (self mutateConstraints: aPath pathConstraints).
	
	path parent: aPath parent.
	path inputFrame: aPath inputs.
	path exitCondition: aPath exitCondition.
	^ path
	
	
	
	
	 
	
	
]

{ #category : 'as yet unclassified' }
Mutator >> mutateAddConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Mutator >> mutateAndConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Mutator >> mutateBitAddConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Mutator >> mutateBitOrConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Mutator >> mutateBitShiftConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Mutator >> mutateConstraint: aConstraint [

	^ aConstraint mutate: self
]

{ #category : 'as yet unclassified' }
Mutator >> mutateConstraints: someConstraints [ 
	^  someConstraints collect: [ :constraint | self mutateConstraint: constraint ].
]

{ #category : 'as yet unclassified' }
Mutator >> mutateDivisionConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Mutator >> mutateEqualsConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateGreaterConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateGreaterOrEqualsConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsBooleanObjectOfConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsCharacterObjectConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsClassIndexOfConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsContextObjectConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsFloatObjectOfConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsIntegerObjectConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsIntegerObjectOfConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsIntegerToFloatConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsNonCharacterConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateIsNonIntegerConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateLessConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateLessOrEqualsConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateModuloConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Mutator >> mutateMultiplicationConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Mutator >> mutateNotEqualsConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateOrConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
Mutator >> mutateQuotientConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Mutator >> mutateSubstractionConstraint: aConstraint [

	^ self subclassResponsibility
]
