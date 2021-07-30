Class {
	#name : #RAIsImmediateObject,
	#superclass : #RAPathConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #negating }
RAIsImmediateObject >> negated [
	
	^ RAIsNonTaggedObject operands: self operands
]

{ #category : #adding }
RAIsImmediateObject >> prettyIdentifier [

	^ 'isIntegerObject'
]

{ #category : #adding }
RAIsImmediateObject >> prettyString [

	^ 'isIntegerObject(', operands first prettyString, ')'
]
