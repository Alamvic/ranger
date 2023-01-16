Class {
	#name : #RAAddConstraint,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RAAddConstraint >> evaluateWith: aRAObjectBuilder [ 
	
	^ (operands first evaluateWith: aRAObjectBuilder) + (operands second evaluateWith: aRAObjectBuilder)
]

{ #category : #microzinc }
RAAddConstraint >> mzConstraintOnInterpreter: interpreter [ 
	
	| leftOperand rightOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	^ leftOperand + rightOperand
]

{ #category : #adding }
RAAddConstraint >> prettyString [

	^ String streamContents: [ :str |
		self operands
			do: [ :op | str nextPutAll: op prettyString ]
			separatedBy: [ str nextPutAll: ' + ' ]]
]
