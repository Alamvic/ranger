Class {
	#name : #RAPathConstraint,
	#superclass : #RAConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #converting }
RAPathConstraint >> normalize [

	self operands first isConstant ifTrue: [ ^ self invert ].
	^ self
]
