 # Import policy definition JSON from file
 $policyContent = Get-Content -Path './builtin-policy.json' -Raw
 $policyContent = $policyContent.Trim()
 $policyDefinition = $policyContent | ConvertFrom-Json -Depth 100 
 
 # Access specific properties and convert them to strings
 $displayName = $policyDefinition.properties.displayName.ToString()
 $policyRule = $policyDefinition.properties.policyRule | ConvertTo-Json -Compress -Depth 100
 $description = $policyDefinition.properties.description.ToString()
 
 # Create or update the policy definition
 New-AzPolicyDefinition `
   -Name $displayName `
   -Policy $policyRule `
   -Description $description `
   -DisplayName $displayName `
   -Mode Indexed `
   -SubscriptionId $env:AZURE_SUBSCRIPTION_ID
 
 #Get the Policy definition
 $policy = Get-AzPolicyDefinition -Name $displayName
 
 # Assign the policy
 New-AzPolicyAssignment `
   -Name "$displayName-Assignment" `
   -PolicyDefinition $policy `
   -Scope "/subscriptions/$env:AZURE_SUBSCRIPTION_ID"