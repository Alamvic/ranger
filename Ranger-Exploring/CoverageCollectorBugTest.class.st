Class {
	#name : 'CoverageCollectorBugTest',
	#superclass : 'TestCase',
	#instVars : [
		'collector'
	],
	#category : 'Ranger-Exploring-Collector',
	#package : 'Ranger-Exploring',
	#tag : 'Collector'
}

{ #category : 'as yet unclassified' }
CoverageCollectorBugTest >> setUp [
	super setUp.

	collector := CoverageCollector new.
]

{ #category : 'as yet unclassified' }
CoverageCollectorBugTest >> testCoverFirstBlockBehaviorOfAmethodWithMultipleReturnBlocks [

	| target result |
	
	target := TestClassToCover new.
	
	collector methods: TestClassToCover methods.
	result := collector runOn: [
		target aMethodWithTwoReturnBlocks: true returnWithIter: 0
	].

	self assert: (result percentage) equals: 50.
	self assert: (result partiallyCoveredMethods first) equals: TestClassToCover methods first.

]

{ #category : 'as yet unclassified' }
CoverageCollectorBugTest >> testCoverSecondBlockBehaviorOfAmethodWithMultipleReturnBlocks [

	| target result statements |
	
	target := TestClassToCover new.
	
	collector methods: TestClassToCover methods.
	result := collector runOn: [
		target aMethodWithTwoReturnBlocks: false returnWithIter: 5
	].

	statements := TestClassToCover methods first ast body allStatements.
	self assert: (result percentage) equals: 50.
	self assert: (result partiallyCoveredMethods first) equals: TestClassToCover methods first.

]
