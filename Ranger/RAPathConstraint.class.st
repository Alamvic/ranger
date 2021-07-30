Class {
	#name : #RAPathConstraint,
	#superclass : #RAConstraint,
	#category : #Ranger
}

{ #category : #converting }
RAPathConstraint >> normalize [

	self operands first isConstant ifTrue: [ ^ self invert ].
	^ self
]
