param (
    [string]$PolicyDefinitionName,
    [string]$PolicyDisplayName,
    [string]$PolicyRulePath,
    [string]$PolicyParametersPath
)

# Log in to Azure (uses existing GitHub credentials)
Connect-AzAccount -Identity

# Read policy rule and parameters
$PolicyRule = Get-Content -Raw -Path $PolicyRulePath | ConvertFrom-Json
$PolicyParameters = Get-Content -Raw -Path $PolicyParametersPath | ConvertFrom-Json

# Deploy the policy definition
New-AzPolicyDefinition -Name $PolicyDefinitionName `
    -DisplayName $PolicyDisplayName `
    -PolicyRule $PolicyRule `
    -Parameters $PolicyParameters `
    -Mode All -PolicyType Custom

Write-Output "Policy '$PolicyDisplayName' deployed successfully."

# Assign the policy to a specific scope
$AssignmentName = "KeyVaultEnableSsoftDeleteAssignment"
$Scope = "/subscriptions/f147463c-0679-4251-8f65-6e4b481e4f07/resourceGroups/TestRG"
$Parameters = @{}

if ($PolicyParameters) {
    $Parameters = $PolicyParameters
}

New-AzPolicyAssignment -Name $AssignmentName `
    -PolicyDefinitionName $PolicyDefinitionName `
    -Scope $Scope `
    -PolicyParameterObject $Parameters

Write-Output "Policy '$PolicyDisplayName' assigned to scope '$Scope' with assignment name '$AssignmentName'."
