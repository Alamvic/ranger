Class {
	#name : 'RALessConstraint',
	#superclass : 'RAPathConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'evaluating' }
RALessConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) < (operands second evaluateWith: anObjectBuilder)
]

{ #category : 'transformations' }
RALessConstraint >> invert [

	^ RAGreaterOrEqualsConstraint operands: self operands reversed
]

{ #category : 'as yet unclassified' }
RALessConstraint >> mutate: mutator [

	^ mutator mutateLessConstraint: self
]

{ #category : 'microzinc' }
RALessConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand lowerThan: rightOperand
]

{ #category : 'negating' }
RALessConstraint >> negated [

	^ RAGreaterOrEqualsConstraint operands: self operands
]

{ #category : 'accessing' }
RALessConstraint >> operator [
	
	^ '<'
]
