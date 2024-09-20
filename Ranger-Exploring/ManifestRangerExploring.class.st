"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestRangerExploring',
	#superclass : 'PackageManifest',
	#category : 'Ranger-Exploring-Manifest',
	#package : 'Ranger-Exploring',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestRangerExploring class >> ruleSelfSentNotImplementedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#IdleMutatorTest #setup #false)) #'2024-09-18T15:42:25.406397+02:00') )
]

{ #category : 'code-critics' }
ManifestRangerExploring class >> ruleSentNotImplementedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#IdleMutatorTest #setup #false)) #'2024-09-18T15:42:06.617511+02:00') )
]

{ #category : 'code-critics' }
ManifestRangerExploring class >> ruleUnclassifiedMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#IdMutator #mutateConstraint: #false)) #'2024-09-18T17:19:50.544958+02:00') #(#(#RGMethodDefinition #(#Mutator #mutate: #false)) #'2024-09-18T17:21:53.160732+02:00') #(#(#RGMethodDefinition #(#Mutator #mutateConstraints: #false)) #'2024-09-19T09:18:23.401388+02:00') )
]

{ #category : 'code-critics' }
ManifestRangerExploring class >> ruleUncommonMessageSendRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#IdleMutatorTest #setup #false)) #'2024-09-18T15:42:19.064266+02:00') )
]
