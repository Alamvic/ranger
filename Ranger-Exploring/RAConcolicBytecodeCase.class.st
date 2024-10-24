Class {
	#name : 'RAConcolicBytecodeCase',
	#superclass : 'RAConcolicCase',
	#instVars : [
		'bytecode',
		'methodAddress'
	],
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

{ #category : 'accessing' }
RAConcolicBytecodeCase >> bytecode: anObject [

	bytecode := anObject.
]

{ #category : 'executing' }
RAConcolicBytecodeCase >> executePrimitiveFailure: aRAPrimitiveFailure [ 
	
	"If this is a primitive failure during a bytecode instruction, this means it was a success!
	Actually, this means that the bytecode tried to execute a primitive inside, it failed, and tried something else.
	If this were a real failure case, the exit status would be another one (like send exit)"
	aTest executeUntilReturn
]

{ #category : 'testing' }
RAConcolicBytecodeCase >> isInvalidMemoryAccessInvalid [
	
	"Bytecode assume all objects are correct... Otherwise it's a bytecode sequence problem"
	^ true
]

{ #category : 'running' }
RAConcolicBytecodeCase >> prepareAutoCall [

	| receiver |
	receiver := aTest objectBuilder instantiate: solution inputConstraints receiver.
	aTest
		prepareStackForSendReceiver: receiver
		arguments: (solution inputConstraints arguments collect: [:e | (aTest objectBuilder instantiate: e) ]).
	
	"previous frame"
	aTest pushAddress: aTest machineSimulator framePointerRegisterValue.
	aTest machineSimulator framePointerRegisterValue: aTest machineSimulator smalltalkStackPointerRegisterValue.
	
	aTest pushAddress: (aTest objectBuilder instantiate: solution inputConstraints method).
	aTest pushAddress: 0. "context"
	aTest pushAddress: receiver.

	solution inputConstraints locals do: [ :aLocalValue | 
		aTest pushAddress: (aTest objectBuilder instantiate: aLocalValue) ]
]

{ #category : 'running' }
RAConcolicBytecodeCase >> runOn: theTest [

	"Setting test instance"
	| cogit |
	aTest := theTest.
	aTest setUp: self.
	
	(solution isInvalidIn: self) ifTrue: [ ^ self ].
	
	cogit := aTest cogit.
	
	methodAddress := theTest compile: [ | descriptor result |
		cogit needsFrame: true.
		cogit methodObj: (aTest objectBuilder instantiate: solution inputConstraints method).
		cogit byte0: bytecode.
		cogit bytecodePC: 0.
		cogit endPC: 0.
		solution inputConstraints operandStack reversed do: [ :aStackValue | 
			cogit genPushLiteral: (aTest objectBuilder instantiate: aStackValue) ].

		descriptor := cogit generatorAt: bytecode.
		result := cogit perform: descriptor generator.
		solution exitCondition returnResultInto: self
	] bytecodes: 15.

	self prepareAutoCall.
	self execute.

]
