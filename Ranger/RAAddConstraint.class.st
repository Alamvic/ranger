Class {
	#name : #RAAddConstraint,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #adding }
RAAddConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

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
		  integerValue: leftValue + rightValue;
		  yourself "Native value"
]

{ #category : #microzinc }
RAAddConstraint >> mzConstraintOnInterpreter: interpreter [ 
	
	| leftOperand rightOperand leftValue rightValue |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.
	rightOperand := operands second mzConstraintOnInterpreter: interpreter.

	leftValue := leftOperand integerValue.
	rightValue := rightOperand integerValue.

	^ (RAObject named: UUID new asString)
		  typeTag: 2 asMzValue;
		  integerValue: leftValue + rightValue;
		  yourself "Native value"
]

{ #category : #adding }
RAAddConstraint >> prettyString [

	^ String streamContents: [ :str |
		self operands
			do: [ :op | str nextPutAll: op prettyString ]
			separatedBy: [ str nextPutAll: ' + ' ]]
]
