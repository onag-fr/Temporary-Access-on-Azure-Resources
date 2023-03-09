Param(
	[Parameter(Mandatory=$false)] [string] $EnvironmentKey= "",
    [Parameter(Mandatory=$false)] [string] $ResourceGroupName = "",
   	[Parameter(Mandatory=$false)] [string] $AppServiceName = ""
)

$ips = Get-Content "Manage_Access_IPs/Kudu/dev_team_ips.txt" #Path of your txt file that contain the IP to allow/remove
$Conf = Get-AzWebAppAccessRestrictionConfig -ResourceGroupName $ResourceGroupName -Name $AppServiceName

Try {
        if ($ips -eq $null)
                {
                    Write-Host "IP file is empty!"
                }else
                    {
                    foreach ($ip in $ips) 
                        {
                            if ($Conf.ScmSiteAccessRestrictions.IpAddress -eq $ip)
                            {
                                Write-Host "IP already allowed: $ip"
                            }else
                                {
                                Add-AzWebAppAccessRestrictionRule `
                                -ResourceGroupName $ResourceGroupName `
                                -WebAppName $AppServiceName `
                                -TargetScmSite `
                                -Name Temp_DEV_IP -Priority 666 -Action Allow -IpAddress $ip
                                
                                Write-Host "IP just allowed: $ip"
                                }
                            }  
                }          
    } Catch {
        Write-Error ("An error occured: $($_.Exception.Message)")
}