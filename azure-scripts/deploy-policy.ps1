 # Import policy definition JSON from file
 $policyContent = Get-Content -Path './builtin-policy.json' -Raw
 $policyContent = $policyContent.Trim()
 $policyDefinition = $policyContent | ConvertFrom-Json -Depth 100 
 
 # Access specific properties and convert them to strings
 $displayName = $policyDefinition.properties.displayName.ToString()
 $policyRule = $policyDefinition.properties.policyRule | ConvertTo-Json -Compress -Depth 100
 $description = $policyDefinition.properties.displayName.ToString()
 
 # Create or update the policy definition
 New-AzPolicyDefinition `
   -Name $displayName `
   -Policy $policyRule `
   -Description $description `
   -DisplayName $displayName `
   -Mode Indexed `
   -SubscriptionId 'f147463c-0679-4251-8f65-6e4b481e4f07'
 
 #Get the Policy definition
 $policy = Get-AzPolicyDefinition -Name $displayName
 
 # Assign the policy
 New-AzPolicyAssignment `
   -Name "$displayName-Assignment" `
   -PolicyDefinition $policy `
   -Scope "/subscriptions/f147463c-0679-4251-8f65-6e4b481e4f07"