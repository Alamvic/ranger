Class {
	#name : #RASuccess,
	#superclass : #Object,
	#category : #'Ranger-Interpreter'
}

{ #category : #testing }
RASuccess >> isInvalid [

	^ false
]

{ #category : #compiling }
RASuccess >> returnResultInto: compiler [ 
	
	"I'm a success and my value has been pushed to the operand stack.
	Make a return top"

	compiler genReturnTopFromMethod
]
