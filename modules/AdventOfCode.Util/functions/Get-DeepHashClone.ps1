function Get-DeepHashClone {
    param(
        [Parameter(Mandatory)]
        [object]$Object
    )

    $newObject = @{}
    foreach ($key in $object.Keys) {
        $newObject.Add($key, $object[$key].Clone()) | out-null
    }
    $newObject

}