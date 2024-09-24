Class {
	#name : 'ConstraintsMutator',
	#superclass : 'Object',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutate: aPath [

	| path | 
	path := RAPath new.
	path pathConstraints: (self mutateConstraints: aPath pathConstraints).
	
	path parent: aPath parent.
	path inputFrame: aPath inputs.
	path exitCondition: aPath exitCondition.
	^ path
	
	
	
	
	 
	
	
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateAddConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateAndConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateBitAddConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateBitOrConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateBitShiftConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateConstraint: aConstraint [

	^ aConstraint mutate: self
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateConstraints: someConstraints [ 
	^  someConstraints collect: [ :constraint | self mutateConstraint: constraint ].
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateDivisionConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateEqualsConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateGreaterConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateGreaterOrEqualsConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsBooleanObjectOfConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsCharacterObjectConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsClassIndexOfConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsContextObjectConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsFloatObjectOfConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsIntegerObjectConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsIntegerObjectOfConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsIntegerToFloatConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsNonCharacterConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateIsNonIntegerConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateLessConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateLessOrEqualsConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateModuloConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateMultiplicationConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateNotEqualsConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateOrConstraint: aConstraint [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateQuotientConstraint: aConstraint [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ConstraintsMutator >> mutateSubstractionConstraint: aConstraint [

	^ self subclassResponsibility
]
