Class {
	#name : #RAIsNonIntegerObject,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #negating }
RAIsNonIntegerObject >> mzConstraintOnInterpreter: anInterpreter [

	^ operands first typeTag notEquals: 1
]

{ #category : #negating }
RAIsNonIntegerObject >> negated [
	
	^ RAIsIntegerObject operands: self operands
]
