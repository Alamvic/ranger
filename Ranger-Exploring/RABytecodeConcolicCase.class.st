Class {
	#name : 'RABytecodeConcolicCase',
	#superclass : 'RAVMConcolicCase',
	#instVars : [
		'bytecode',
		'vm'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'accessing' }
RABytecodeConcolicCase >> bytecode [

	^ bytecode
]

{ #category : 'accessing' }
RABytecodeConcolicCase >> bytecode: anObject [

	bytecode := anObject
]

{ #category : 'initialization' }
RABytecodeConcolicCase >> initializeVM: aVM [
	
	aVM currentBytecode: bytecode
]

{ #category : 'accessing' }
RABytecodeConcolicCase >> selector [
	
	^ vm class bytecodeTable at: bytecode + 1
]

{ #category : 'accessing' }
RABytecodeConcolicCase >> vm [

	^ vm
]

{ #category : 'accessing' }
RABytecodeConcolicCase >> vm: anObject [

	vm := anObject
]
