param (
    [string]$PolicyDefinitionName,
    [string]$PolicyDisplayName,
    [string]$PolicyRulePath,
    [string]$PolicyParametersPath,
    [string]$AssignmentName,
    [string]$Scope
)

# Log in to Azure using GitHub Actions' Managed Identity
Connect-AzAccount -Identity

# Read the policy rule and parameters from files
$PolicyRule = Get-Content -Raw -Path $PolicyRulePath | ConvertFrom-Json
$PolicyParameters = Get-Content -Raw -Path $PolicyParametersPath | ConvertFrom-Json

# Deploy the policy definition
New-AzPolicyDefinition -Name $PolicyDefinitionName `
    -DisplayName $PolicyDisplayName `
    -PolicyRule $PolicyRule `
    -Parameters $PolicyParameters `
    -Mode All -PolicyType Custom

Write-Output "Policy '$PolicyDisplayName' deployed successfully."

# Assign the policy to the specified scope
New-AzPolicyAssignment -Name $AssignmentName `
    -PolicyDefinitionName $PolicyDefinitionName `
    -Scope $Scope `
    -PolicyParameterObject $PolicyParameters

Write-Output "Policy '$PolicyDisplayName' assigned to scope '$Scope' with assignment name '$AssignmentName'."
