$oTPM = gwmi -Class Win32_TPM -Namespace root\CIMV2\Security\MicrosoftTpm

$oTPM.SetPhysicalPresenceRequest(10)

If(!(($oTPM.IsEndorsementKeyPairPresent()).IsEndorsementKeyPairPresent)){

$oTPM.CreateEndorsementKeyPair()

}

If(($oTPM.IsEndorsementKeyPairPresent()).IsEndorsementKeyPairPresent){

$OwnerAuth=$oTPM.ConvertToOwnerAuth(“customrandompassword”)

$oTPM.Clear($OwnerAuth.OwnerAuth)

$oTPM.TakeOwnership($OwnerAuth.OwnerAuth)

}
