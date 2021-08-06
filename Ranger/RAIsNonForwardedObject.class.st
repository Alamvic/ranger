Class {
	#name : #RAIsNonForwardedObject,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #negating }
RAIsNonForwardedObject >> negated [
	
	^ RAIsForwardedObject operands: self operands
]
