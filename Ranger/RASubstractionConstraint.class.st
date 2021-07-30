Class {
	#name : #RASubstractionConstraint,
	#superclass : #RAValueConstraint,
	#category : #Ranger
}

{ #category : #adding }
RASubstractionConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand rightOperand leftValue rightValue |
	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.
	rightOperand := operands second
		                addToSolver: aSolver
		                withVariables: variables
		                interpreter: interpreter.

	leftValue := leftOperand integerValue.
	rightValue := rightOperand integerValue.

	^ (RAObject named: UUID new asString)
		  typeTag: 2;
		  integerValue: leftValue - rightValue;
		  yourself "Native integer"
]
