Class {
	#name : 'RALessOrEqualsConstraint',
	#superclass : 'RAPathConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'evaluating' }
RALessOrEqualsConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) <= (operands second evaluateWith: anObjectBuilder)
]

{ #category : 'transformations' }
RALessOrEqualsConstraint >> invert [

	^ RAGreaterConstraint operands: self operands reversed
]

{ #category : 'as yet unclassified' }
RALessOrEqualsConstraint >> mutate: mutator [

	^ mutator mutateLessOrEqualsConstraint: self
]

{ #category : 'microzinc' }
RALessOrEqualsConstraint >> mzConstraintOnInterpreter: interpreter [
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand lessOrEquals: rightOperand
]

{ #category : 'negating' }
RALessOrEqualsConstraint >> negated [
	
	^ RAGreaterConstraint operands: self operands
]
