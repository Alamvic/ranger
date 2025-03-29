Class {
	#name : 'RABitShiftConstraint',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'as yet unclassified' }
RABitShiftConstraint >> mutate: mutator [

	^ mutator mutateBitShiftConstraint: self
]

{ #category : 'printing' }
RABitShiftConstraint >> operator [

	^ '<<' "OR should we use >> ?"
]

{ #category : 'as yet unclassified' }
RABitShiftConstraint >> simplify [

	"If possible, replace shift by multiplication"
	(operands second isConstant and: [ operands second value > 0 ])
		ifTrue: [ 
			^ RAMultiplicationConstraint operands: { 
				operands first.
				RAConstant value: (2 raisedTo: operands second value) } ].

	(operands second isConstant and: [ operands second value < 0 ])
		ifTrue: [ 
			^ RADivisionConstraint operands: { 
				operands first.
				RAConstant value: (2 raisedTo: operands second value abs) } ].
	^ self
]
