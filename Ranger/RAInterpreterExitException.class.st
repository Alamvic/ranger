Class {
	#name : 'RAInterpreterExitException',
	#superclass : 'Error',
	#instVars : [
		'exitCondition'
	],
	#category : 'Ranger-Interpreter',
	#package : 'Ranger',
	#tag : 'Interpreter'
}

{ #category : 'accessing' }
RAInterpreterExitException >> exitCondition [

	^ exitCondition
]

{ #category : 'accessing' }
RAInterpreterExitException >> exitCondition: anObject [

	exitCondition := anObject
]
