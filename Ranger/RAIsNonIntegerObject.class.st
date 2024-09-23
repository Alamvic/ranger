Class {
	#name : 'RAIsNonIntegerObject',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'as yet unclassified' }
RAIsNonIntegerObject >> mutate: mutator [

	^ mutator mutateIsNonIntegerConstraint: self
]

{ #category : 'negating' }
RAIsNonIntegerObject >> mzConstraintOnInterpreter: anInterpreter [

	^ operands first typeTag notEquals: 1
]

{ #category : 'negating' }
RAIsNonIntegerObject >> negated [
	
	^ RAIsIntegerObject operands: self operands
]
