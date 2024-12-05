function New-StateMachine() {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [String]$initialState
    )
 
    [StateMachine]::New($initialState)
}